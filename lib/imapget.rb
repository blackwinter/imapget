#--
###############################################################################
#                                                                             #
# imapget -- Download IMAP mails                                              #
#                                                                             #
# Copyright (C) 2009-2011 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
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
require 'enumerator' unless [].respond_to?(:each_slice)

require 'imapget/version'

class IMAPGet

  include Enumerable

  STRATEGIES       = [:include, :exclude]
  DEFAULT_STRATEGY = :exclude

  DEFAULT_LEVEL = 2
  DEFAULT_DELIM = '/'

  FETCH_ATTR = %w[FLAGS INTERNALDATE RFC822]
  FETCH_SIZE = 100

  attr_reader   :imap, :strategy, :incl, :excl
  attr_accessor :log_level

  def initialize(options)
    @log_level = options[:log_level] || DEFAULT_LEVEL

    init_imap    options
    authenticate options
    inclexcl     options
  end

  def inclexcl(options)
    inclexcl = {}

    delim = Regexp.escape(options[:delim] || DEFAULT_DELIM)

    STRATEGIES.each { |key|
      inclexcl[key] = case value = options[key]
        when String
          Regexp.new(value)
        when Array
          Regexp.new(value.map { |v|
            "\\A#{Regexp.escape(Net::IMAP.encode_utf7(v))}(?:#{delim}|\\z)"
          }.join('|'))
      end
    }

    @incl, @excl = inclexcl.values_at(:include, :exclude)
    @strategy = options[:strategy] || DEFAULT_STRATEGY
  end

  def mailboxes
    @mailboxes ||= imap.list('', '*')
  end

  def each
    mailboxes.each { |mailbox|
      name = mailbox.name

      case strategy
        when :include
          next if (excl && name =~ excl) || !(incl && name =~ incl)
        when :exclude
          next if (excl && name =~ excl) && !(incl && name =~ incl)
      end

      yield mailbox if self.include?(mailbox)
    }
  end

  def include?(mailbox_or_name)
    !exclude?(mailbox_or_name)
  end

  def exclude?(mailbox_or_name)
    name = case mailbox_or_name
      when Net::IMAP::MailboxList then mailbox_or_name.name
      when String                 then mailbox_or_name
      else
        raise TypeError, "MailboxList or String expected, got #{mailbox_or_name.class}"
    end

    case strategy
      when :include
        (excl && name =~ excl) || !(incl && name =~ incl)
      when :exclude
        (excl && name =~ excl) && !(incl && name =~ incl)
    end
  end

  def get(path)
    each { |mailbox|
      name   = mailbox.name
      dir    = File.join(path, Net::IMAP.decode_utf7(name))
      update = check_dir(dir)

      log "#{'=' * 10} #{name} #{'=' * 10}"
      imap.examine(name)

      uids = imap.uid_search("SINCE #{update.strftime('%d-%b-%Y')}")
      next if uids.empty?

      fetch(uids) { |mail, uid, flags, date, body|
        file    = File.join(dir, uid.to_s)
        exists  = File.exists?(file)
        deleted = flags.include?(Net::IMAP::DELETED)

        if deleted
          if exists
            info "#{dir}: #{name} <- #{uid}"
            File.unlink(file)
          end
        else
          unless exists && File.mtime(file) >= date
            info "#{dir}: #{name} -> #{uid}"
            File.open(file, 'w') { |f| f.puts body }
          end
        end
      }
    }
  end

  alias_method :download, :get

  private

  def init_imap(options)
    @imap = Net::IMAP.new(
      options[:host],
      options[:port] || Net::IMAP::PORT,
      options[:use_ssl],
      options[:certs],
      options[:verify]
    )
  end

  def authenticate(options)
    imap.authenticate(
      imap.capability.include?('AUTH=CRAM-MD5') ? 'CRAM-MD5' : 'LOGIN',
      options[:user], options[:password]
    )
  end

  def fetch(uids, fetch_size = FETCH_SIZE, fetch_attr = FETCH_ATTR)
    uids.each_slice(fetch_size) { |slice|
      imap.uid_fetch(slice, fetch_attr).each { |mail|
        yield mail, *['UID', *fetch_attr].map { |a|
          v = mail.attr[a]
          v = Time.parse(v) if a == 'INTERNALDATE'
          v
        }
      }
    }
  end

  def check_dir(dir)
    if File.directory?(dir)
      File.mtime(dir)
    else
      FileUtils.mkdir_p(dir)
      Time.at(0)
    end.utc
  end

  def log(msg, level = 1)
    warn msg if log_level >= level
  end

  def info(msg)
    log(msg, 2)
  end

end
