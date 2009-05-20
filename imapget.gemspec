# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{imapget}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2009-05-20}
  s.default_executable = %q{imapget}
  s.description = %q{Get IMAP mails.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.executables = ["imapget"]
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/imapget.rb", "lib/imapget/version.rb", "bin/imapget", "COPYING", "Rakefile", "README", "ChangeLog", "example/config.yaml"]
  s.homepage = %q{http://github.com/blackwinter/imapget}
  s.rdoc_options = ["--all", "--line-numbers", "--main", "README", "--inline-source", "--title", "imapget Application documentation", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Get IMAP mails.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
  end
end
