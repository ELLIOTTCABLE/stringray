($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'stringray'
require 'extlib/string' # String#/, because I'm a lazy fuck.
require 'rake'
require 'yard'
require 'yard/rake/yardoc_task'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

begin
  require 'echoe'
  
  namespace :echoe do
    Echoe.new('StringRay', StringRay::VERSION) do |g|
      g.name = 'stringray'
      g.author = ['elliottcable']
      g.email = ['StringRay@elliottcable.com']
      g.summary = 'Combining many of the benefits of Arrays and Strings, StringRay allows you to treat a String as an Array of words in many cases.'
      g.url = 'http://github.com/elliottcable/stringray'
      g.dependencies = []
      g.manifest_name = '.manifest'
      g.ignore_pattern = /(^\.git$|^\.yardoc$|^meta\/|\.gemspec$)/
    end
  
    desc 'tests packaged files to ensure they are all present'
    task :verify => :package do
      # An error message will be displayed if files are missing
      if system %(ruby -e "require 'rubygems'; require 'pkg/stringray-#{StringRay::VERSION}/lib/stringray'")
        puts "\nThe library files are present"
      end
    end

    task :copy_gemspec => [:package] do
      pkg = Dir['pkg/*'].select {|dir| File.directory? dir}.last
      mv File.join(pkg, pkg.gsub(/^pkg\//,'').gsub(/\-\d+$/,'.gemspec')), './'
    end

    desc 'builds a gemspec as GitHub wants it'
    task :gemspec => [:package, :copy_gemspec, :clobber_package]

    # desc 'Run specs, clean tree, update manifest, run coverage, and install gem!'
    desc 'Clean tree, update manifest, and install gem!'
    task :magic => [:clean, :manifest, :install]
  end
  
  task :manifest => [:'echoe:manifest']
  
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
      t.options = ['--output-dir', "meta/documentation"]
    end
    
    YARD::Rake::YardocTask.new :dot_yardoc do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--no-output']
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
                :'echoe:manifest',
                :'rcov:run', :'rcov:verify', :'rcov:open',
                :'git:status']

  # desc 'Task run during continuous integration' # Invisible
  task :ci => [:'yard:generate', :'rcov:plain', :'rcov:verify']
end