require "rake/clean"

NAMESPACE = "org.fanaugen.arrange_windows".freeze

def lib_path
  File.join(Dir.home, "Library", "Script Libraries", NAMESPACE)
end

CLEAN.concat ["compiled", lib_path]

directory "compiled/lib"
directory lib_path

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

desc "Symlinks compiled libraries to ~/Library/Script Libraries"
task :link_libraries => ["compiled/lib", lib_path] do
  if Dir.glob("compiled/lib/*").any?
    sh "ln -sf #{File.join(Dir.pwd, "compiled/lib/*.scpt")} '#{lib_path}'"
  end
end
