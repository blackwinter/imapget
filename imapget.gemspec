# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{imapget}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jens Wille}]
  s.date = %q{2011-08-16}
  s.description = %q{Get IMAP mails.}
  s.email = %q{jens.wille@gmail.com}
  s.executables = [%q{imapget}]
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{ChangeLog}]
  s.files = [%q{lib/imapget/version.rb}, %q{lib/imapget.rb}, %q{bin/imapget}, %q{README}, %q{ChangeLog}, %q{COPYING}, %q{Rakefile}, %q{example/config.yaml}]
  s.homepage = %q{http://imapget.rubyforge.org/}
  s.rdoc_options = [%q{--charset}, %q{UTF-8}, %q{--line-numbers}, %q{--all}, %q{--title}, %q{imapget Application documentation (v0.0.7)}, %q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{imapget}
  s.rubygems_version = %q{1.8.8}
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
