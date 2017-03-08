# source files exist in the top-level directory, as well as under lib
# steps needed to compile a bundled AppleScript with all the libraries bundled into it:
#
# 1. Compile all dependencies in lib/
# 2. Symlink them into ~/Library/Script\ Libraries/ so osascript can pick them up
# 3. Compile the main script, which uses `use script` statements
#
# To bundle:
# 4. Compile the main script as a bundle
# 5. move or copy the compiled depencencies into the bundle’s Contents/Resources/Script Libraries/
require "rake/clean"

CLEAN.concat ["compiled"]

directory "compiled/lib"

task :default => :build

desc "Compiles applescripts in ./lib and in the project root"
task :build => [:build_libraries, :link_libraries] do
  FileList["*.applescript"].each do |source|
    sh "osacompile -o compiled/#{File.basename(source, ".*")}.scpt #{source}"
  end
end

desc "Compiles all the applescripts in ./lib"
task :build_libraries => ["compiled/lib"] do
  FileList["lib/*.applescript"].each do |library|
    target = File.join("compiled/lib", "#{File.basename(library, ".*")}.scpt")
    sh "osacompile -o #{target} #{library}"
  end
end

task :link_libraries => ["compiled/lib"] do
desc "Symlinks compiled libraries to ~/Library/Script Libraries"
  if Dir.glob("compiled/lib/*").any?
    sh "ln -sf #{File.join(Dir.pwd, "compiled/lib/*.scpt")} ~/Library/Script\\ Libraries"
  end
end
