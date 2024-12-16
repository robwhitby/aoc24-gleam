import dir
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import grid.{type Grid, Cell}
import input
import point.{type Point}

fn parse(in: List(String)) {
  let g = input.string_parser(in, "") |> grid.from_list
  let assert Ok(start) = grid.find(g, fn(v) { v == "S" })
  let assert Ok(end) = grid.find(g, fn(v) { v == "E" })
  #(g, start.point, end.point)
}

pub fn part1(in: List(String)) -> Int {
  let #(g, start, end) = parse(in)
  let from = #(start, dir.e, 0)

  walk(g, [from], dict.new())
  |> dict.get(end)
  |> result.unwrap(0)
}

fn walk(
  g: Grid(String),
  from: List(#(Point, Point, Int)),
  visited: Dict(Point, Int),
) {
  let already_beaten = fn(p, v) {
    dict.get(visited, p) |> result.map(fn(x) { x <= v }) == Ok(True)
  }
  case from {
    [] -> visited
    [#(p, d, score), ..tail] -> {
      case already_beaten(p, score) {
        True -> walk(g, tail, visited)
        False -> {
          let nexts =
            list.filter_map([d, dir.rotate90(d), dir.rotate270(d)], fn(d1) {
              case grid.cell_at(g, point.add(p, d1)) {
                Ok(Cell(p1, v1)) if v1 == "." || v1 == "E" -> {
                  let step_score = case d == d1 {
                    True -> 1
                    False -> 1001
                  }
                  Ok(#(p1, d1, score + step_score))
                }
                _ -> Error(Nil)
              }
            })
          walk(g, list.flatten([nexts, tail]), dict.insert(visited, p, score))
        }
      }
    }
  }
}

pub fn part2(_in: List(String)) -> Int {
  0
}
