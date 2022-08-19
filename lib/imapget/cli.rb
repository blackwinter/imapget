#--
###############################################################################
#                                                                             #
# imapget -- Download IMAP mails                                              #
#                                                                             #
# Copyright (C) 2009-2014 Jens Wille                                          #
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

require 'cyclops'
require 'imapget'

class IMAPGet

  class CLI < Cyclops

    class << self

      def defaults
        super.merge(
          config:    'config.yaml',
          directory: nil,
          check:     false,
          dupe:      false,
          uniq:      false
        )
      end

    end

    def usage
      "#{super} [profile]..."
    end

    def run(arguments)
      default_config, profiles = config.delete(:default_config), config.to_a

      (arguments.empty? ? profiles.map(&:first) : arguments).each { |profile|
        profile_config = profile_config(profile, profiles, default_config) or next

        imapget = IMAPGet.new(profile_config)

        if options[:check]
          imapget.each { |mailbox| puts mailbox.name }
        elsif options[:dupes]
          imapget.each { |mailbox| imapget.dupes(mailbox.name) }
        elsif options[:uniq]
          imapget.each { |mailbox| imapget.uniq!(mailbox.name) {
            next unless agree('Really delete duplicates? ')
          } }
        else
          imapget.get(options[:directory] ||
            File.join(profile_config[:base_dir] || '.', profile.to_s))
        end
      }
    end

    private

    def merge_config(*)
    end

    def opts(opts)
      opts.option(:directory__PATH, 'Path to directory to store mails in [Default: BASE_DIR/<profile>]')

      opts.separator

      opts.switch(:check, :C, "Only check include/exclude statements; don't download any mails")

      opts.switch(:dupes, :D, "Only check for duplicate mails; don't download any mails")

      opts.switch(:uniq, :U, "Only delete duplicate mails; don't download any mails")
    end

    def profile_config(profile, profiles, default_config)
      unless config = profiles.assoc(profile)
        warn "No such profile: #{profile}"
        return
      end

      config = config.last
      default_config.each { |key, value| config[key] ||= value }

      return if config[:skip]

      unless host = config[:host]
        warn "No host for profile: #{profile}"
        return
      end

      config[:user]     ||= ask("User for #{profile} on #{host}: ")
      config[:password] ||= askpass("Password for #{config[:user]}@#{host}: ")

      config
    end

  end

end
