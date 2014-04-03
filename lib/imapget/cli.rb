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

require 'nuggets/cli'

require 'imapget'

class IMAPGet

  class CLI < Nuggets::CLI

    class << self

      def defaults
        super.merge(
          config:    'config.yaml',
          directory: nil,
          check:     false
        )
      end

    end

    def usage
      "#{super} [profile]..."
    end

    def run(arguments)
      profiles, default_config = config.partition { |k,| k.is_a?(String) }

      (arguments.empty? ? profiles.map(&:first) : arguments).each { |profile|
        unless profile_config = profiles.assoc(profile)
          warn "No such profile: #{profile}"
          next
        end

        profile_config = profile_config.last
        default_config.each { |key, value| profile_config[key] ||= value }

        next if profile_config[:skip]

        unless host = profile_config[:host]
          warn "No host for profile: #{profile}"
          next
        end

        profile_config[:user]     ||= ask("User for #{profile} on #{host}: ")
        profile_config[:password] ||= askpass("Password for #{profile_config[:user]}@#{host}: ")

        imapget = IMAPGet.new(profile_config)

        if options[:check]
          imapget.each { |mailbox| puts mailbox.name }
        else
          imapget.get(options[:directory] || File.join(profile_config[:base_dir] || '.', profile))
        end
      }
    end

    private

    def merge_config(*)
    end

    def opts(opts)
      opts.on('-d', '--directory PATH', "Path to directory to store mails in [Default: BASE_DIR/<profile>]") { |d|
        options[:directory] = d
      }

      opts.separator ''

      opts.on('-C', '--check', "Only check include/exclude statements; don't download any mails") {
        options[:check] = true
      }
    end

  end

end
