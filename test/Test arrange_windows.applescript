prop parent : script "com.lifepillar/ASUnit"
prop suite : makeTestSuite("Test the main script")
global implementation
global Math
autorun(suite)

script |Test arrange_windows|
  prop parent : TestSet(me)

  script |load implementation|
    prop parent : UnitTest(me)

    set project_root to do shell script¬
      "echo " & POSIX path of (path to me) & " | sed -E s:/test/.*::"
    set implementation to load script file POSIX file (project_root & "/arrange_windows.scpt")
    assertInstanceOf(script, implementation)
    set Math to script "org.fanaugen.arrange_windows/Math"
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

  script |SlotCalculator's factors (private helper method)|
    prop parent : UnitTest(me)
    set subject to implementation's SlotCalculator

    -- factors are the square root of the number is a square
    assertEqual({2, 2}, subject's factors(4))
    assertEqual({3, 3}, subject's factors(9))
    assertEqual({12, 12}, subject's factors(144))

    -- factors are integers
    set factors to subject's factors(51)
    assertInstanceOf(integer, item 1 of factors)
    assertInstanceOf(integer, item 2 of factors)

    -- the factors' product is at least equal to the number
    set product to (first item of factors) * (second item of factors)
    assert((product is greater than or equal to 51),¬
      "product of factors must be at least equal to number")

    -- the factors don't differ by more than 1
    set f1 to subject's factors(13)
    set f2 to subject's factors(14)
    set f3 to subject's factors(15)
    set diff1 to Math's abs(item 1 of f1 - item 2 of f1)
    set diff2 to Math's abs(item 1 of f2 - item 2 of f2)
    set diff3 to Math's abs(item 1 of f3 - item 2 of f3)
    set msg to "factors mustn't differ by more than 1"
    assert(diff1 is less than or equal to 1, msg)
    assert(diff2 is less than or equal to 1, msg)
    assert(diff3 is less than or equal to 1, msg)
  end
end
