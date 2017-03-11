prop parent : script "com.lifepillar/ASUnit"
prop suite : makeTestSuite("Test the ListUtil library")
global ListUtil
autorun(suite)

script |Test ListUtil|
    prop parent : TestSet(me)

    script |load implementation|
      prop parent : UnitTest(me)

      set project_root to do shell script¬
        "echo " & POSIX path of (path to me) & " | sed -E s:/test/.*::"
      set ListUtil to load script file POSIX file (project_root & "/lib/ListUtil.scpt")
      assertInstanceOf(script, ListUtil)
    end

    script |flatten|
      prop parent : UnitTest(me)
      assertEqual({"flat", "list", 42, 7}, ListUtil's flatten({{"flat"}, "list", {42, {7}}}))
    end
end
