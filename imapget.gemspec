# -*- encoding: utf-8 -*-
# stub: imapget 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "imapget"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-04-14"
  s.description = "Download e-mails from IMAP servers."
  s.email = "jens.wille@gmail.com"
  s.executables = ["imapget"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "bin/imapget", "example/config.yaml", "lib/imapget.rb", "lib/imapget/cli.rb", "lib/imapget/version.rb"]
  s.homepage = "http://github.com/blackwinter/imapget"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nimapget-0.1.0 [2014-04-14]:\n\n* Added options <tt>--dupes</tt> and <tt>--uniq</tt>.\n* Added STARTTLS support.\n* Added LOGIN as fallback for AUTHENTICATE.\n* Added +batch_size+ option.\n* Dropped +use_ssl+ options; use +ssl+ instead.\n* Dropped support for Ruby 1.8.\n* Internal refactoring.\n\n"
  s.rdoc_options = ["--title", "imapget Application documentation (v0.1.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2"
  s.summary = "Get IMAP mails."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cyclops>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0.9.8"])
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<cyclops>, [">= 0"])
      s.add_dependency(%q<ruby-nuggets>, [">= 0.9.8"])
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<cyclops>, [">= 0"])
    s.add_dependency(%q<ruby-nuggets>, [">= 0.9.8"])
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
