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
end
