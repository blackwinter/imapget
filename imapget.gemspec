# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{imapget}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2011-04-29}
  s.description = %q{Get IMAP mails.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.executables = ["imapget"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/imapget.rb", "lib/imapget/version.rb", "bin/imapget", "README", "ChangeLog", "Rakefile", "COPYING", "example/config.yaml"]
  s.homepage = %q{http://imapget.rubyforge.org/}
  s.rdoc_options = ["--line-numbers", "--main", "README", "--charset", "UTF-8", "--all", "--title", "imapget Application documentation (v0.0.6)"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{imapget}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Get IMAP mails.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
  end
end
