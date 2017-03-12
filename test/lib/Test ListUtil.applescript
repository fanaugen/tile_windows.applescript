prop parent : script "com.lifepillar/ASUnit"
prop suite : makeTestSuite("Test the ListUtil library")
global ListUtil
autorun(suite)

script |Test ListUtil|
  prop parent : TestSet(me)

  script |load ListUtil|
    prop parent : UnitTest(me)

    set project_root to do shell script¬
      "echo " & POSIX path of (path to me) & " | sed -E s:/test/.*::"
    set ListUtil to load script file POSIX file (project_root & "/lib/ListUtil.scpt")
    assertInstanceOf(script, ListUtil)
  end

  script |flatten|
    prop parent : UnitTest(me)
    assertEqual({"flat", "list", 42, 7},¬
      ListUtil's flatten({{"flat"}, "list", {42, {7}}})¬
    )
    assertEqual({"flat", "list"}, ListUtil's flatten({"flat", "list"}))
  end

  script |any|
    prop parent : UnitTest(me)

    script invalidCriteria
      ListUtil's any({2, -1, 9}, "dummy")
    end
    shouldRaise(-1708, invalidCriteria, "criteria must respond to `check`")

    script negative
      to check(num)
        num < 0
      end
    end
    script validCriteria
      ListUtil's any({2, -1, 9}, negative)
    end
    shouldNotRaise({}, validCriteria, "criteria respond to `check`")
    assertEqual(true, ListUtil's any({2, -1, 9}, negative))
    assertEqual(false, ListUtil's any({2, 1, 9}, negative))
  end
end
