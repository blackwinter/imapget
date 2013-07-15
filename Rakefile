require File.expand_path(%q{../lib/imapget/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{imapget},
      :version      => IMAPGet::VERSION,
      :summary      => %q{Get IMAP mails.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :license      => %q{AGPL},
      :homepage     => :blackwinter,
      :dependencies => %w[highline]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
