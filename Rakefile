require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'

task :default => "test"

namespace :test do
  desc "Test all classes"
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.pattern = 'test/*_test.rb'
    t.verbose = true
  end 
end

desc "Run all the unit tests"
task :test do
  Rake::Task["test:all"].invoke
end

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'jump'
  rdoc.options << '--line-numbers' << "--main" << "README.rdoc"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = %q{jump}
    s.summary     = %q{A bookmarking system for the bash shell}
    s.description = %q{Jump is a tool that allows you to quickly change
                       directories in the bash shell using bookmarks.
                       Thanks to Jump, you won't have to type those long paths anymore.

                       Jump was inspired by go-tool by ActiveState
                       (http://code.google.com/p/go-tool/).}

    s.files        = FileList['[A-Z]*', 'lib/**/*.rb', 'test/**/*.rb']
    s.require_path = 'lib'
    s.bindir = 'bin'
    s.executables = ['jump-bin']
    s.test_files   = Dir[*['test/**/*_test.rb']]

    s.has_rdoc         = true
    s.extra_rdoc_files = ["README.rdoc"]
    s.rdoc_options = ['--line-numbers', "--main", "README.rdoc"]

    s.authors = ["Flavio Castelli", "Giuseppe Capizzi"]
    s.email   = %w(flavio@castelli.name gcapizzi@gmail.com)
    s.homepage = "http://github.com/gcapizzi/jump"

    s.add_dependency "terminal-table"
    s.add_development_dependency "fakefs"

    s.platform = Gem::Platform::RUBY
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

desc "Clean files generated by rake tasks"
task :clobber => [:clobber_rdoc]
