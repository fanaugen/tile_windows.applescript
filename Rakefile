require "tmpdir"
require "rake/clean"

NAMESPACE      = "org.fanaugen.arrange_windows".freeze
AS_LIB_PATH    = File.join(Dir.home, "Library", "Script Libraries")
LIB_PATH       = File.join(AS_LIB_PATH, NAMESPACE)
TEST_FRAMEWORK = File.join(AS_LIB_PATH, "com.lifepillar", "ASUnit.scptd")

CLEAN.include "**/*.scpt", LIB_PATH

directory LIB_PATH
directory File.dirname(TEST_FRAMEWORK)

task :default => :build

desc "Compiles applescripts in ./lib and in the project root"
task :build => :build_libraries do
  FileList["*.applescript"].include("test/**/*.applescript").each do |source|
    sh "osacompile -o '#{source.ext("scpt")}' '#{source}'"
  end
end

desc "Compiles scripts in ./lib, symlinks them to ~/Library/Script Libraries"
task :build_libraries => LIB_PATH do
  FileList["lib/*.applescript"].each do |library|
    sh "osacompile -o lib/#{File.basename(library, ".*")}.scpt #{library}"
  end
  ln_sf Dir.glob(File.join(Dir.pwd, "lib/*.scpt")), LIB_PATH
end

desc "Compiles a single .applescript file"
task :compile, [:source_file] do |t, args|
  verbose(false)
  sh "osacompile -o '#{args.source_file.ext("scpt")}' '#{args.source_file}'"
end

desc "Runs the test suite"
task :test => [TEST_FRAMEWORK] do
  verbose(false)
  sh "osascript \"test/Test Loader.scpt\""
end

desc "Installs the testing framework ASUnit"
file TEST_FRAMEWORK => File.dirname(TEST_FRAMEWORK) do
  working_directory = Dir.getwd
  Dir.mktmpdir do |tmp|
    begin
      cd tmp
      sh "git clone --depth=1 git@github.com:lifepillar/ASUnit.git"
      cd "ASUnit"
      sh "osacompile -o ASUnit.scptd ASUnit.applescript"
      mv "ASUnit.scptd", TEST_FRAMEWORK
    ensure
      cd working_directory
    end
  end
end
