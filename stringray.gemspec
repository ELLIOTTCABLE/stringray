# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stringray}
  s.version = "3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["elliottcable"]
  s.date = %q{2009-06-11}
  s.description = %q{Combining many of the benefits of Arrays and Strings, StringRay allows you to treat a String as an Array of words in many cases.}
  s.email = ["StringRay@elliottcable.com"]
  s.extra_rdoc_files = ["lib/stringray.rb", "lib/stringray/core_ext.rb", "lib/stringray/core_ext/kernel.rb", "lib/stringray/core_ext/spec/rake/verify_rcov.rb", "README.markdown"]
  s.files = ["lib/stringray.rb", "lib/stringray/core_ext.rb", "lib/stringray/core_ext/kernel.rb", "lib/stringray/core_ext/spec/rake/verify_rcov.rb", "spec/stringray_spec.rb", "README.markdown", "Rakefile.rb", ".manifest", "stringray.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/elliottcable/stringray}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Stringray", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{stringray}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Combining many of the benefits of Arrays and Strings, StringRay allows you to treat a String as an Array of words in many cases.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<elliottcable-echoe>, [">= 0", "= 3.0.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
