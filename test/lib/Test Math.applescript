prop parent : script "com.lifepillar/ASUnit"
prop suite : makeTestSuite("Test the Math utility library")
global Math
autorun(suite)

script |Test Math|
    prop parent : TestSet(me)

    script |load implementation|
      prop parent : UnitTest(me)

      set project_root to do shell script¬
        "echo " & POSIX path of (path to me) & " | sed -E s:/test/.*::"
      set Math to load script file POSIX file (project_root & "/lib/Math.scpt")
      assertInstanceOf(script, Math)
    end

    script |absolute value|
      prop parent : UnitTest(me)

      assertEqual(5, Math's abs(-5))
      assertEqual(8, Math's abs(8))
    end

    script |in_range|
      prop parent : UnitTest(me)

      ok(Math's in_range(5, 1, 10))
      ok(Math's in_range(3, 3, 10))
      ok(Math's in_range(9, 1, 9))
      notOk(Math's in_range(5, 7, 9))
      notOk(Math's in_range(9, 3, 5))
    end

    script |min and max|
      prop parent : UnitTest(me)
      set nums to {-3, 2, 45}
      assertEqual(-3, Math's min(nums))
      assertEqual(45, Math's max(nums))
      assertEqual(7, Math's max({7}))
      assertEqual(9, Math's min({9, 9, 9}))
    end

    script |square root|
      prop parent : UnitTest(me)
      assertEqual(12.0, Math's sqrt(144))
      assertEqual(5.0, Math's sqrt(25))
    end

    script |factors of a square|
      prop parent : UnitTest(me)
      assertEqual({2, 2}, Math's factors(4))
      assertEqual({3, 3}, Math's factors(9))
      assertEqual({12, 12}, Math's factors(144))
    end

    script |product of factors greater than or equal to number|
      prop parent : UnitTest(me)
      set factors to Math's factors(51)
      set product to (first item of factors) * (second item of factors)
      assert((product is greater than or equal to 51),¬
        "product of factors must be at least equal to number")
    end

    script |factors are both integers|
      prop parent : UnitTest(me)
      set factors to Math's factors(51)
      assertInstanceOf(integer, item 1 of factors)
      assertInstanceOf(integer, item 2 of factors)
    end
end
