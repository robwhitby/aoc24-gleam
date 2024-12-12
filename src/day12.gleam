import gleam/int
import gleam/list
import gleam/set
import grid
import input

fn parse(in: List(String)) {
  input.string_parser(in, "")
  |> grid.from_list
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> grid.areas
  |> list.map(fn(area) { set.size(area) * grid.perimeter(area) })
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> grid.areas
  |> list.map(fn(area) { set.size(area) * grid.sides(area) })
  |> int.sum
}
