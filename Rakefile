require File.expand_path(%q{../lib/imapget/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{imapget},
      version:      IMAPGet::VERSION,
      summary:      %q{Get IMAP mails.},
      description:  %q{Download e-mails from IMAP server.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: %w[highline] << ['ruby-nuggets', '>= 0.9.8'],

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
