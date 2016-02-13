require_relative 'lib/imapget/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{imapget},
      version:      IMAPGet::VERSION,
      summary:      %q{Get IMAP mails.},
      description:  %q{Download e-mails from IMAP servers.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: { cyclops: '~> 0.2', nuggets: '~> 1.4' },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
