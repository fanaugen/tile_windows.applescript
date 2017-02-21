# Utility script that gathers info about the Dock and Desktop
script OSX
  prop dock_dimensions: 0
  prop dock_hidden: false
  prop desktop_dimensions: {}

  on run()
    tell application "System Events"
      set my dock_dimensions to (get size of first UI element of process "Dock")
    end

    tell application "Finder"
      set my desktop_dimensions to the bounds of desktop's window
    end

    set my dock_hidden to ("1" = (do shell script "defaults read com.apple.dock autohide"))
  end
end

run OSX
# OSX's desktop_dimensions

script ListUtil
  # recursive flatten stolen from: http://macscripter.net/viewtopic.php?pid=140475#p140475
  on flatten(nested_list)
    script flattener
      property flat_list : {}
      property ref_fl : reference to my flat_list

      on recursive_flatten(_list)
        repeat with i from 1 to (count _list)
          set _value to item i of _list
          if (_value's class is list) then
            recursive_flatten(_value)
          else
            copy _value to the end of my ref_fl
          end
        end
      end
    end

    tell flattener
      recursive_flatten(nested_list)
      return its flat_list
    end
  end

  on any(_list, criteria)
    repeat with i from 1 to (count _list)
      if (criteria's check(item i of _list)) then return true
    end
    false
  end
end

tell application "System Events"
  set visible_windows to ListUtil's flatten(¬
    get every window of (every application process whose visible is true)¬
  )
end

script Math
	on abs(num)
		if num < 0 then return 0 - num
		num
	end

	on max(_list)
		set m to 0
		repeat with X in _list
			if X > m then set m to X
		end
		return m as number
	end

	on min(_list)
		set m to item 1 of _list
		repeat with Y in rest of _list
			if Y < m then set m to Y
		end
		return m as number
	end

	on sqrt(num)
		num ^ 0.5
	end
end

# wrapper for coordinate pair
on coords({_x, _y})
	script MyPoint
    prop parent: {_x, _y}
		prop posx : _x
		prop posy : _y

		on distance_to(other)
			Math's sqrt((posx - (other's posx)) ^ 2 + (posy - (other's posy)) ^ 2)
		end

    to to_pair()
      {posx, posy}
    end
	end
	return MyPoint
end

# pos: coords of upper left corner; dim: {width, height}
on rect({pos, dim})
	script Rectangle
    prop parent: coords(pos)
		prop dimensions : dim
		prop dimx : item 1 of dim
		prop dimy : item 2 of dim
    # corners
		prop tl : coords({my posx        , my posy})
    prop tr : coords({my posx + dimx , my posy})
		prop bl : coords({my posx        , my posy + dimy})
    prop br : coords({my posx + dimx , my posy + dimy})
    prop corners: {tl, tr, bl, br}

		on overlaps(other) # true if this rect overlaps with the other
      script are_inside
        to check(p)
          includes(p)
        end
      end
      ListUtil's any(other's corners, are_inside)
		end

    on includes(p) # a point
      (my posx < p's posx and p's posx < tr's posx) and ¬
      (my posy < p's posy and p's posy < br's posy)
    end
	end

	return Rectangle
end

