import gleam/io
import grid
import input

fn parse(in: List(String)) {
  input.string_parser(in, "")
  |> grid.from_list
}

pub fn part1(in: List(String)) -> Int {
  let g = parse(in)

  0
}

pub fn part2(_in: List(String)) -> Int {
  0
}
