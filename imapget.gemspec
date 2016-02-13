# -*- encoding: utf-8 -*-
# stub: imapget 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "imapget".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2016-02-13"
  s.description = "Download e-mails from IMAP servers.".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.executables = ["imapget".freeze]
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "bin/imapget".freeze, "example/config.yaml".freeze, "lib/imapget.rb".freeze, "lib/imapget/cli.rb".freeze, "lib/imapget/version.rb".freeze]
  s.homepage = "http://github.com/blackwinter/imapget".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nimapget-0.2.0 [2016-02-13]:\n\n* Fixed batch fetching.\n* Internal refactoring.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "imapget Application documentation (v0.2.0)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Get IMAP mails.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cyclops>.freeze, ["~> 0.2"])
      s.add_runtime_dependency(%q<nuggets>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<cyclops>.freeze, ["~> 0.2"])
      s.add_dependency(%q<nuggets>.freeze, ["~> 1.4"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<cyclops>.freeze, ["~> 0.2"])
    s.add_dependency(%q<nuggets>.freeze, ["~> 1.4"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
