#--
###############################################################################
#                                                                             #
# imapget -- Download IMAP mails                                              #
#                                                                             #
# Copyright (C) 2009 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# imapget is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU General Public License as published by the Free        #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# imapget is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more       #
# details.                                                                    #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with imapget. If not, see <http://www.gnu.org/licenses/>.                   #
#                                                                             #
###############################################################################
#++

require 'time'
require 'net/imap'
require 'fileutils'

require 'imapget/version'

class IMAPGet

  include Enumerable

  STRATEGIES       = [:include, :exclude]
  DEFAULT_STRATEGY = :exclude

  DEFAULT_DELIM = '/'

  attr_reader   :imap, :strategy, :incl, :excl
  attr_accessor :log_level

  def initialize(options)
    @imap = Net::IMAP.new(
      options[:host],
      options[:port] || Net::IMAP::PORT,
      options[:use_ssl],
      options[:certs],
      options[:verify]
    )

    @imap.authenticate(
      @imap.capability.include?('AUTH=CRAM-MD5') ? 'CRAM-MD5' : 'LOGIN',
      options[:user], options[:password]
    )

    inclexcl(options)

    @log_level = 2
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
        raise TypeError, "String or MailboxList expected, got #{mailbox_or_name.class}"
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
      name = mailbox.name
      dir  = File.join(path, Net::IMAP.decode_utf7(name))

      if File.directory?(dir)
        last_update = File.mtime(dir)
      else
        FileUtils.mkdir_p(dir)
        last_update = Time.at(0)
      end

      log "#{'=' * 10} #{name} #{'=' * 10}"
      imap.examine(name)

      uids = imap.uid_search("SINCE #{last_update.utc.strftime('%d-%b-%Y')}")
      next if uids.empty?

      imap.uid_fetch(uids, %w[RFC822 INTERNALDATE FLAGS]).each { |mail|
        uid   = mail.attr['UID']
        flags = mail.attr['FLAGS']
        file  = File.join(dir, uid.to_s)
        date  = Time.parse(mail.attr['INTERNALDATE'])

        deleted = flags.include?(Net::IMAP::DELETED)
        exists  = File.exists?(file)

        if deleted
          if exists
            info "#{dir}: #{name} <- #{uid}"
            File.unlink(file)
          end
        else
          unless exists && File.mtime(file) >= date
            info "#{dir}: #{name} -> #{uid}"
            File.open(file, 'w') { |f| f.puts mail.attr['RFC822'] }
          end
        end
      }
    }
  end

  alias_method :download, :get

  private

  def log(msg, level = 1)
    warn msg if log_level >= level
  end

  def info(msg)
    log(msg, 2)
  end

end
