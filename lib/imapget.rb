#--
###############################################################################
#                                                                             #
# imapget -- Download IMAP mails                                              #
#                                                                             #
# Copyright (C) 2009-2016 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# imapget is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# imapget is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with imapget. If not, see <http://www.gnu.org/licenses/>.             #
#                                                                             #
###############################################################################
#++

require 'time'
require 'net/imap'
require 'fileutils'
require 'nuggets/hash/zip'

require_relative 'imapget/version'

class IMAPGet

  include Enumerable

  DEFAULT_BATCH_SIZE = 100
  DEFAULT_STRATEGY   = :exclude
  DEFAULT_LOG_LEVEL  = 2
  DEFAULT_DELIMITER  = '/'

  FETCH_ATTR = %w[FLAGS INTERNALDATE RFC822]

  attr_reader   :imap, :strategy, :incl, :excl
  attr_accessor :batch_size, :log_level

  def initialize(options)
    @batch_size = options.fetch(:batch_size, DEFAULT_BATCH_SIZE)
    @log_level  = options.fetch(:log_level,  DEFAULT_LOG_LEVEL)

    @imap = Net::IMAP.new(options[:host], options)
    @imap.starttls(options[:starttls]) if options[:starttls]

    authenticate(options)
    inclexcl(options)
  end

  def inclexcl(options)
    delim = Regexp.escape(options.fetch(:delim, DEFAULT_DELIMITER))

    %w[include exclude].each { |key|
      instance_variable_set("@#{key[0, 4]}", case value = options[key.to_sym]
        when String then Regexp.new(value)
        when Array  then Regexp.new(value.map { |v|
          "\\A#{Regexp.escape(Net::IMAP.encode_utf7(v))}(?:#{delim}|\\z)"
        }.join('|'))
      end)
    }

    @strategy = options.fetch(:strategy, DEFAULT_STRATEGY)
  end

  def mailboxes
    @mailboxes ||= imap.list('', '*').sort_by(&:name)
  end

  def each
    mailboxes.each { |mailbox| yield mailbox if include?(mailbox) }
  end

  def include?(mailbox)
    !exclude?(mailbox)
  end

  def exclude?(mailbox)
    name = case mailbox
      when String                 then mailbox
      when Net::IMAP::MailboxList then mailbox.name
      else raise TypeError, "MailboxList or String expected, got #{mailbox.class}"
    end

    case strategy
      when :include then (excl && name =~ excl) || !(incl && name =~ incl)
      when :exclude then (excl && name =~ excl) && !(incl && name =~ incl)
    end
  end

  def get(dir)
    each { |mailbox| get_name(name = mailbox.name,
      File.join(dir, Net::IMAP.decode_utf7(name))) }
  end

  alias_method :download, :get

  def get_name(name, dir)
    log "#{'=' * 10} #{name} #{'=' * 10}"

    imap.examine(name)

    imap.uid_search("SINCE #{mtime(dir)}").each_slice(batch_size) { |batch|
      fetch_batch(batch) { |mail| fetch(mail, dir, name) }
    }
  end

  alias_method :download_name, :get_name

  def size(name, attr = 'MESSAGES')
    imap.status(name, [attr]).values.first
  end

  def dupes(name, quiet = false)
    imap.examine(name)

    hash = Hash.zipkey { |h, k| h[k] = [] }

    1.step(size(name), step = batch_size) { |i|
      fetch_batch([[i, step]]) { |mail|
        hash[mail.attr['RFC822']] << mail.attr['UID'] unless deleted?(mail)
      }
    }

    dupes = hash.flat_map { |_, uids| uids.drop(1) if uids.size > 1 }.compact

    log "#{name}: #{dupes.size}" unless quiet

    dupes
  end

  def delete!(name, uids)
    unless uids.empty?
      log "#{name}: #{uids.size}"

      yield if block_given?

      imap.select(name)
      count = imap.store(uids, '+FLAGS', [Net::IMAP::DELETED]).size

      log "#{count} DELETED!"

      count
    end
  end

  def uniq!(name, &block)
    delete!(name, dupes(name, true), &block)
  end

  private

  def authenticate(options)
    if auth = options.fetch(:auth) {
      imap.capability.grep(/\AAUTH=(.*)/) { $1 }.first
    }
      imap.authenticate(auth, options[:user], options[:password])
    else
      imap.login(options[:user], options[:password])
    end
  end

  def fetch_batch(batch, fetch_attr = FETCH_ATTR, &block)
    if batch.size == 1
      case set = batch.first
        when Array
          batch = set.first .. (set.first + set.last - 1)
        when Range
          batch = set.first .. (set.last - 1) if set.exclude_end?
      end
    end

    mails = imap.uid_fetch(batch, fetch_attr)
    mails.each(&block) if mails
  end

  def fetch(mail, dir, name)
    uid    = mail.attr['UID'].to_s
    file   = File.join(dir, uid)
    exists = File.exists?(file)

    if deleted?(mail)
      if exists
        info "#{dir}: #{name} <- #{uid}"
        File.unlink(file)
      end
    else
      date = mail.attr['INTERNALDATE']

      unless exists && date && File.mtime(file) >= Time.parse(date)
        info "#{dir}: #{name} -> #{uid}"
        File.write(file, mail.attr['RFC822'])
      end
    end
  end

  def deleted?(mail)
    mail.attr['FLAGS'].include?(Net::IMAP::DELETED)
  end

  def mtime(dir)
    Net::IMAP.format_date((File.directory?(dir) ?
      File.mtime(dir) : (FileUtils.mkdir_p(dir); Time.at(0))).utc)
  end

  def log(msg, level = 1)
    warn msg if log_level >= level
  end

  def info(msg)
    log(msg, 2)
  end

end
