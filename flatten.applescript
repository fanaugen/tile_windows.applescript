script ListUtil
	on flatten(listOfLists)
		script flattener
			property flat_list : {}
			
			on recursive_flatten(_list)
				script _current
					property _item : _list
				end script
				
				repeat with i from 1 to (count _list)
					set _value to item i of _current's _item
					if (_value's class is list) then
						recursive_flatten(_value)
					else
						copy _value to the end of my flat_list
					end if
				end repeat
			end recursive_flatten
		end script
		
		tell flattener
			recursive_flatten(listOfLists)
			return its flat_list
		end tell
	end flatten
end script


tell application "System Events"
	
	set visible_windows to ListUtil's flatten(get every window of (every application process whose visible is true))
end