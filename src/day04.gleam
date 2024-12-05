import dir
import gleam/list
import gleam/set
import gleam/string
import grid
import input.{type InputStrings}

pub fn part1(in: InputStrings) -> Int {
  grid.from_list(in)
  |> grid.lines(dir.all)
  |> grid.find_in_lines(string.to_graphemes("XMAS"))
  |> list.length
}

pub fn part2(in: InputStrings) -> Int {
  let a =
    grid.from_list(in)
    |> grid.lines(dir.diag)
    |> grid.find_in_lines(string.to_graphemes("MAS"))
    |> list.filter_map(fn(mas) { list.find(mas, fn(c) { c.value == "A" }) })

  list.length(a) - set.size(set.from_list(a))
}
