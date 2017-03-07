use scripting additions
use ListUtil : script "ListUtil"
use Math : script "Math"

# Utility script that gathers info about the Dock and Desktop
script OSX
  prop dock_pos: {}
  prop dock_dim: {}
  prop dock_hidden: false
  prop dock_orientation: "bottom"
  prop desktop_pos: {0, 0}
  prop desktop_dim: {}
  prop menubar_hidden: false
  prop menubar_dim: {}

  to read_setting(domain, key, default)
    try
      set value to (do shell script ("defaults read " & domain & " " & key))
    on error
      set value to default
    end
    return value
  end

  on run()
    tell application "System Events"
      set the_dock to the first UI element of process "Dock"
      set my dock_pos to (get position of the_dock)
      set my dock_dim to (get size of the_dock)
    end

    tell application "Finder"
      set {_, _, w, h} to (bounds of the window of the desktop)
      set my desktop_dim to {w, h}
      set my menubar_dim to {w, 22}
    end

    set my dock_hidden to ("1" is equal to (read_setting("com.apple.dock", "autohide", "0")))
    set my dock_orientation to read_setting("com.apple.dock", "orientation", "bottom")
    set my menubar_hidden to ("1" is equal to read_setting("NSGlobalDomain", "_HIHideMenuBar", "0"))
  end

  on getAvailableSurface() # rectangle that can be filled with windows
    run me # to set all the properties
    set surface to rect({desktop_pos, desktop_dim})
    if not menubar_hidden
      set menubar_height to (second item of menubar_dim) as number
      set surface to surface's reduce by menubar_height from "top"
    end

    if (not dock_hidden) and (surface's overlaps(rect(dock_pos, dock_dim)))
      set surface to surface's reduce by (Math's min(dock_dim)) from dock_orientation
    end

    return surface
  end
end

# return {¬
#   desktop_pos: desktop_pos of OSX,¬
#   desktop_dim: desktop_dim of OSX,¬
#   dock_pos: dock_pos of OSX,¬
#   dock_dim: dock_dim of OSX,¬
#   dock_hidden: dock_hidden of OSX,¬
#   dock_orientation: dock_orientation of OSX,¬
#   menubar_dim: menubar_dim of OSX,¬
#   menubar_hidden: menubar_hidden of OSX¬
# }

tell application "System Events"
  # set visible_windows to ListUtil's flatten(¬
  #   get every window of (every application process whose visible is true)¬
  # )
end

# wrapper for coordinate pair
on coords({_x, _y})
	script MyPoint
		prop posx : _x
		prop posy : _y

		on distance_to(other)
			Math's sqrt((posx - (other's posx)) ^ 2 + (posy - (other's posy)) ^ 2)
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
    prop maxx : my posx + dimx
    prop maxy : my posy + dimy

		on overlaps(other)
      Math's min({my maxx, other's maxx}) - Math's max({my posx, other's posx}) > 0 and ¬
      Math's min({my maxy, other's maxy}) - Math's max({my posy, other's posy}) > 0
		end

    on includes(p) # a point
      Math's in_range(p's posx, my posx, tr's posx) and ¬
      Math's in_range(p's posy, my posy, br's posy)
    end

    to reduce by pixels from direction
      if direction = "top"
        rect({{my posx, my posy + pixels}, {dimx, dimy - pixels}})
      else if direction = "bottom"
        rect({{my posx, my posy}, {dimx, dimy - pixels}})
      else if direction = "left"
        rect({{my posx + pixels, my posy}, {dimx - pixels, dimy}})
      else if direction = "right"
        rect({{my posx, my posy}, {dimx - pixels, dimy}})
      end
    end
	end

	return Rectangle
end

set rect1 to rect({{0, 0}, {100, 100}})
set rect2 to rect({{-20, 80}, {140, 20}})
set rect3 to rect({{100, 0}, {10, 10}})
# return {rect1's overlaps(rect2), rect1's overlaps(rect3)} # expect {true, false}

set available_surface to OSX's getAvailableSurface()
{posx, posy, dimx, dimy} of available_surface

