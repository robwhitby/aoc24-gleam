import gleam/dict
import gleam/list
import gleam/yielder
import grid.{type Grid}
import input.{type InputStrings}
import point.{type Point, Point}

pub fn part1(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  antenna_pairs(g)
  |> antinodes_part1(g)
  |> list.length
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

fn antinodes_part1(pairs: List(#(Point, Point)), g: Grid(a)) {
  pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair
    let step = point.subtract(a, b)
    [point.add(a, step), point.subtract(b, step)]
  })
  |> list.flatten
  |> list.unique
  |> list.filter(grid.contains(g, _))
}

fn antinodes_part2(pairs: List(#(Point, Point)), g: Grid(String)) {
  pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair
    let step_a = point.subtract(a, b)
    let step_b = point.subtract(b, a)
    [grid.line(g, a, step_a), grid.line(g, b, step_b)]
    |> yielder.concat
    |> yielder.to_list
  })
  |> list.flatten
  |> list.unique
}
