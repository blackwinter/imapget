# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "imapget"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-07-15"
  s.description = "Get IMAP mails."
  s.email = "jens.wille@gmail.com"
  s.executables = ["imapget"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/imapget.rb", "lib/imapget/version.rb", "bin/imapget", "COPYING", "ChangeLog", "README", "Rakefile", "example/config.yaml"]
  s.homepage = "http://github.com/blackwinter/imapget"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "imapget Application documentation (v0.0.7)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.5"
  s.summary = "Get IMAP mails."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
  end
end
