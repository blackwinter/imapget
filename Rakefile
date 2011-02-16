require File.expand_path(%q{../lib/imapget/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{imapget}
    },

    :gem => {
      :version      => IMAPGet::VERSION,
      :summary      => %q{Get IMAP mails.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@uni-koeln.de},
      :dependencies => %w[highline]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
