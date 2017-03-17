on abs(num)
  if num < 0 then return 0 - num
  num
end

on in_range(num, lower, upper)
  lower <= num and num <= upper
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

(* returns a list of two integers, {cols, rows}, such as:
 * - cols >= rows (because width of display is assumed larger than height)
 * - cols * rows >= num (because all windows need to fit on the grid)
*)
on factors(num)
  set factor to (my sqrt(num)) as integer
  if factor * factor is less than num then
    {factor + 1, factor}
  else
    {factor, factor}
  end
end
