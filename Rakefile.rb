LibName = "stringray"
($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require LibName
Lib = StringRay

default_tasks = Array.new

# =======================
# = Gem packaging tasks =
# =======================
begin
  require 'echoe'
  
  default_tasks << :'package:manifest' unless ENV['CI']
  default_tasks << :'package:verify'
  
  task :install => :'package:install'
  task :package => :'package:package'
  task :manifest => :'package:manifest'
  namespace :package do
    Echoe.new(LibName, Lib::Version) do |g|
      g.author = ['elliottcable']
      g.email = ["#{LibName}@elliottcable.com"]
      g.summary = 'Combining many of the benefits of Arrays and Strings, StringRay allows you to treat a String as an Array of words in many cases.'
      g.url = 'http://github.com/elliottcable/' + LibName
      g.runtime_dependencies = []
      g.development_dependencies = ['echoe >= 3.0.2', 'rspec', 'rcov', 'yard']
      g.manifest_name = '.manifest'
      g.retain_gemspec = true
      g.rakefile_name = 'Rakefile.rb'
      g.ignore_pattern = /^\.git\/|^meta\/|\.gemspec/
    end
  
    desc 'Tests packaged files to ensure they are all present'
    task :verify => :package do
      # An error message will be displayed if files are missing
      if system %(ruby -e "require 'rubygems'; require 'pkg/#{LibName}-#{Lib::Version}/lib/#{LibName}'")
        puts "\nThe library files are present."
      end
    end
  end
  
rescue LoadError => exception
  raise exception unless exception.message =~ /(echoe)$/
  desc '!! You need the `echoe` gem to package or install this project!'
  task :package
end

# =======================
# = Spec/Coverage tasks =
# =======================
begin
  require 'spec'
  require 'rcov'
  require 'spec/rake/spectask'
  
  default_tasks << :'coverage:run'
  default_tasks << :'coverage:open' unless ENV['CI']
  
  task :coverage => :'coverage:run'
  namespace :coverage do
    Spec::Rake::SpecTask.new(:run) do |t|
      t.spec_opts = ["--format", "specdoc"]
      t.spec_opts << "--colour" unless ENV['CI']
      t.spec_files = Dir[File.join('spec', '**', '*_spec.rb')].sort
      t.libs = ['lib']
      t.rcov = true
      t.rcov_opts = ['--exclude-only', '".*"', '--include-file', '"^lib"',
        '--sort', 'loc', '--sort-reverse',
        '--comments', '--profile', '--text-report', '-w' ]
      t.rcov_dir = File.join('meta', 'coverage')
    end
    
    task :open do
      system 'open ' + File.join('meta', 'coverage', 'index.html')
    end if RUBY_PLATFORM =~ /darwin/
  end
  
rescue LoadError => exception
  raise exception unless exception.message =~ /(rcov|spec)$/
  desc '!! You need the `rcov` and `rspec` gems to run specs or coverage!'
  task :coverage
end

# =======================
# = Documentation tasks =
# =======================
begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  
  default_tasks << :'documentation:generate'
  default_tasks << :'documentation:open' unless ENV['CI']
  
  task :documentation => :'documentation:generate'
  namespace :documentation do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = [File.join('lib', '**', '*.rb')]
      t.options = ['--output-dir', File.join('meta', 'documentation'),
                   '--readme', 'README.markdown']
    end
    
    YARD::Rake::YardocTask.new :yardoc do |t|
      t.files   = [File.join('lib', '**', '*.rb')]
      t.options = ['--no-output',
                   '--readme', 'README.markdown']
    end
    
    task :open do
      system 'open ' + File.join('meta', 'documentation', 'index.html')
    end if RUBY_PLATFORM =~ /darwin/
  end
  
rescue LoadError => exception
  raise exception unless exception.message =~ /(yard)$/
  desc '!! You need the `yard` gem to generate documentation!'
  task :documentation
end

# =================
# = Miscellaneous =
# =================
desc 'Removes all meta producs'
task :clobber do
  `rm -rf #{File.expand_path(File.join( File.dirname(__FILE__), 'meta' ))} #{File.expand_path(File.join( File.dirname(__FILE__), 'pkg' ))}`
end

desc 'Run all default tasks'
task :default => default_tasks do
  puts "** Successfully ran the following tasks:"
  puts "** #{Rake.application.tasks.select {|t| t.name == 'default' }.first.prerequisites.join(', ')}"
end
