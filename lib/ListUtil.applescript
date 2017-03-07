# recursive flatten stolen from: http://macscripter.net/viewtopic.php?pid=140475#p140475
on flatten(nested_list)
  script flattener
    property flat_list : {}
    property ref_fl : a reference to my flat_list

    on recursive_flatten(_list)
      repeat with i from 1 to (count _list)
        set _value to item i of _list
        if (_value's class is list) then
          recursive_flatten(_value)
        else
          copy _value to the end of my ref_fl
        end if
      end repeat
    end recursive_flatten
  end script

  tell flattener
    recursive_flatten(nested_list)
    return its flat_list
  end tell
end flatten

on any(_list, criteria)
  repeat with i from 1 to (count _list)
    if (criteria's check(item i of _list)) then return true
  end repeat
  false
end any
