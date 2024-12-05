import gleam/int
import gleam/list
import gleam/string
import grid
import input.{type InputStrings}

pub fn part1(in: InputStrings) -> Int {
  grid.from_list(in)
  |> grid.lines
  |> list.map(string.concat)
  |> list.map(fn(s) { { string.split(s, "XMAS") |> list.length } - 1 })
  |> int.sum
}

pub fn part2(_in: InputStrings) -> Int {
  0
}
