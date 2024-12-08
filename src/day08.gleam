import gleam/dict
import gleam/list
import gleam/yielder
import grid.{type Grid, type Point}
import input.{type InputStrings}

pub fn part1(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  antenna_pairs(g)
  |> antinodes_part1
  |> list.count(grid.contains(g, _))
}

pub fn part2(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  antenna_pairs(g)
  |> antinodes_part2(g)
  |> list.length
}

fn antenna_pairs(g: Grid(String)) -> List(#(Point, Point)) {
  grid.filter(g, fn(v) { v != "." })
  |> list.group(fn(cell) { cell.value })
  |> dict.map_values(fn(_, cells) { list.combination_pairs(cells) })
  |> dict.values()
  |> list.flatten
  |> list.map(fn(p) { #({ p.0 }.point, { p.1 }.point) })
}

fn antinodes_part1(pairs: List(#(Point, Point))) {
  pairs
  |> list.map(fn(p) {
    let #(a, b) = p
    let d = #(a.0 - b.0, a.1 - b.1)
    [#(a.0 + d.0, a.1 + d.1), #(b.0 - d.0, b.1 - d.1)]
  })
  |> list.flatten
  |> list.unique
}

fn antinodes_part2(pairs: List(#(Point, Point)), g: Grid(String)) {
  pairs
  |> list.map(fn(p) {
    let #(a, b) = p
    let da = #(a.0 - b.0, a.1 - b.1)
    let db = #(b.0 - a.0, b.1 - a.1)
    [grid.line(g, a, da), grid.line(g, b, db)]
    |> yielder.concat
    |> yielder.to_list
  })
  |> list.flatten
  |> list.unique
}
