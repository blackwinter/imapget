require %q{lib/imapget/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{},
      :package => %q{imapget}
    },

    :gem => {
      :version      => IMAPGet::VERSION,
      :summary      => %q{Get IMAP mails.},
      :homepage     => %q{http://github.com/blackwinter/imapget},
      :files        => FileList['lib/**/*.rb', 'bin/*'].to_a,
      :extra_files  => FileList['[A-Z]*', 'example/*'].to_a,
      :dependencies => %w[highline]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.
