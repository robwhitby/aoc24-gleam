import gleam/dict
import gleam/list
import grid.{type Grid, type Point}
import input.{type InputStrings}

pub fn part1(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  antenna_pairs(g)
  |> antinodes
  |> list.count(grid.contains(g, _))
}

pub fn part2(_input: InputStrings) -> Int {
  0
}

fn antenna_pairs(g: Grid(String)) -> List(#(Point, Point)) {
  grid.filter(g, fn(v) { v != "." })
  |> list.group(fn(cell) { cell.value })
  |> dict.map_values(fn(_, cells) { list.combination_pairs(cells) })
  |> dict.values()
  |> list.flatten
  |> list.map(fn(p) { #({ p.0 }.point, { p.1 }.point) })
}

fn antinodes(pairs: List(#(Point, Point))) {
  pairs
  |> list.map(fn(p) {
    let #(a, b) = p
    let d = #(a.0 - b.0, a.1 - b.1)
    [#(a.0 + d.0, a.1 + d.1), #(b.0 - d.0, b.1 - d.1)]
  })
  |> list.flatten
  |> list.unique
}
