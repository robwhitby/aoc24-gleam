import dir
import gleam/list
import gleam/set
import gleam/string
import gleam/yielder
import grid.{Cell}
import input

fn parse(in: List(String)) {
  input.string_parser(in, "")
}

pub fn part1(in: List(String)) -> Int {
  let g = grid.from_list(parse(in))
  grid.filter(g, fn(v) { v == "X" })
  |> list.flat_map(fn(cell) { grid.lines(g, cell.point, dir.all) })
  |> list.count(fn(line) {
    yielder.take(line, 4)
    |> yielder.to_list()
    |> list.map(fn(cell) { cell.value })
    |> string.concat
    == "XMAS"
  })
}

pub fn part2(in: List(String)) -> Int {
  let g = grid.from_list(parse(in))
  let a =
    grid.filter(g, fn(v) { v == "M" })
    |> list.flat_map(fn(cell) { grid.lines(g, cell.point, dir.diagonals) })
    |> list.filter_map(fn(line) {
      case yielder.take(line, 3) |> yielder.to_list {
        [Cell(_, "M"), Cell(p, "A"), Cell(_, "S")] -> Ok(p)
        _ -> Error(Nil)
      }
    })

  list.length(a) - set.size(set.from_list(a))
}
