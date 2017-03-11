# modified from template: https://github.com/lifepillar/ASUnit/blob/master/examples/Test%20Loader.applescript
property parent : script "com.lifepillar/ASUnit"

set pwd to folder of file (path to me) of application "Finder"
set lib to item "lib" of pwd

tell makeTestLoader()
  set suite to loadTestsFromFolder(pwd)
  suite's add(loadTestsFromFolder(lib))
end tell

autorun(suite)
