($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'stringray'
require 'extlib/string' # String#/, because I'm a lazy fuck.
require 'rake'
require 'yard'
require 'yard/rake/yardoc_task'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'stringray/core_ext/spec/rake/verify_rcov'

begin
  require 'echoe'
  
  task :package => :'package:package'
  task :install => :'package:install'
  task :manifest => :'package:manifest'
  namespace :package do
    Echoe.new('stringray', StringRay::VERSION) do |g|; g.name = 'StringRay'
      g.project = 'stringray'
      g.author = ['elliottcable']
      g.email = ['StringRay@elliottcable.com']
      g.summary = 'Combining many of the benefits of Arrays and Strings, StringRay allows you to treat a String as an Array of words in many cases.'
      g.url = 'http://github.com/elliottcable/stringray'
      g.dependencies = []
      g.development_dependencies = ['elliottcable-echoe >= 3.0.2', 'rspec', 'rcov', 'yard']
      g.manifest_name = '.manifest'
      g.retain_gemspec = true
      g.rakefile_name = 'Rakefile.rb'
      g.ignore_pattern = /(^\.git$|^\.yardoc$|^meta\/|\.gemspec$)/
    end
  
    desc 'tests packaged files to ensure they are all present'
    task :verify => :package do
      # An error message will be displayed if files are missing
      if system %(ruby -e "require 'rubygems'; require 'pkg/stringray-#{StringRay::VERSION}/lib/stringray'")
        puts "\nThe library files are present"
      end
    end
  end
  
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
ensure
  task :default # No effect # Invisible

  # Runs specs, generates rcov, and opens rcov in your browser.
  namespace :rcov do
    Spec::Rake::SpecTask.new(:run) do |t|
      t.spec_opts = ["--format", "specdoc", "--colour"]
      t.spec_files = Dir['spec/**/*_spec.rb'].sort
      t.libs = ['lib']
      t.rcov = true
      t.rcov_opts = ['--exclude-only', '".*"', '--include-file', '^lib']
      t.rcov_dir = 'meta' / 'coverage'
    end

    Spec::Rake::SpecTask.new(:plain) do |t|
      t.spec_opts = ["--format", "specdoc"]
      t.spec_files = Dir['spec/**/*_spec.rb'].sort
      t.libs = ['lib']
      t.rcov = true
      t.rcov_opts = ['--exclude-only', '".*"', '--include-file', '^lib']
      t.rcov_dir = 'meta' / 'coverage'
    end

    RCov::VerifyTask.new(:verify) do |t|
      t.threshold = 98.7
      t.index_html = 'meta' / 'coverage' / 'index.html'
      t.require_exact_threshold = false
    end

    task :open do
      system 'open ' + 'meta' / 'coverage' / 'index.html' if PLATFORM['darwin']
    end
  end
  
  namespace :yard do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--output-dir', "meta/documentation", '--readme', 'README.markdown']
    end
    
    YARD::Rake::YardocTask.new :dot_yardoc do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--no-output', '--readme', 'README.markdown']
    end
    
    task :open do
      system 'open ' + 'meta' / 'documentation' / 'index.html' if PLATFORM['darwin']
    end
  end
  
  namespace :git do
    task :status do
      `git status`
    end
    
    task :commit => [:'echoe:manifest', :'yard:dot_yardoc'] do
      `git commit`
    end
  end
  
  task :clobber => [:'echoe:clobber_package', :'echoe:clobber_docs', :'echoe:clobber_coverage'] do
    rm_f 'meta'
  end

  desc 'Check everything over before commiting'
  task :aok => [:'yard:generate', :'yard:open',
                :'package:manifest', :'package:package',
                :'rcov:run', :'rcov:verify', :'rcov:open',
                :'git:status']

  # desc 'Task run during continuous integration' # Invisible
  task :ci => [:'yard:generate', :'rcov:plain', :'rcov:verify']
end