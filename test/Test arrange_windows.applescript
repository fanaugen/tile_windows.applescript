prop parent : script "com.lifepillar/ASUnit"
prop suite : makeTestSuite("Test the main script")
global implementation
autorun(suite)

script |Test arrange_windows|
  prop parent : TestSet(me)

  script |load implementation|
    prop parent : UnitTest(me)

    set project_root to do shell script¬
      "echo " & POSIX path of (path to me) & " | sed -E s:/test/.*::"
    set implementation to load script file POSIX file (project_root & "/arrange_windows.scpt")
    assertInstanceOf(script, implementation)
  end

  script |OSX's `read_setting` reads Mac OS X defaults|
    prop parent : UnitTest(me)
    do shell script "defaults write com.apple.Dock my_dummy_key 1"
    assertEqual((implementation's osx)'s read_setting("com.apple.Dock", "my_dummy_key", "default"), "1")
    do shell script "defaults delete com.apple.Dock my_dummy_key"
  end

  script |OSX's `read_setting` applies default when the key-value pair is not found|
    prop parent : UnitTest(me)
    assertEqual("default", implementation's OSX's read_setting("dummy_domain", "dummy_key", "default"))
  end
end
