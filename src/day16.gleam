import dir
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import grid.{type Grid, Cell}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let g = input.string_parser(in, "") |> grid.from_list
  let assert Ok(start) = grid.find(g, fn(v) { v == "S" })
  let assert Ok(end) = grid.find(g, fn(v) { v == "E" })
  #(g, start.point, end.point)
}

pub fn part1(in: List(String)) -> Int {
  let #(g, start, end) = parse(in)
  walk(g, start, end)
  |> pair.first
}

pub fn part2(in: List(String)) -> Int {
  let #(g, start, end) = parse(in)

  walk(g, start, end)
  |> pair.second
  |> list.flatten
  |> list.unique
  |> list.length
}

fn walk(g: Grid(String), from: Point, to: Point) {
  walk_rec(g, [#(from, dir.e, 0, [])], to, dict.new(), [])
}

fn walk_rec(
  g: Grid(String),
  from: List(#(Point, Point, Int, List(Point))),
  to: Point,
  scores: Dict(#(Point, Point), Int),
  routes: List(#(Int, List(Point))),
) {
  case from {
    [] -> {
      let min =
        list.map(routes, pair.first)
        |> list.reduce(int.min)
        |> result.unwrap(0)
      #(min, list.filter(routes, fn(r) { r.0 == min }) |> list.map(pair.second))
    }
    [#(p, d, s, r), ..tail] -> {
      case dict.get(scores, #(p, d)) {
        Ok(n) if n < s -> walk_rec(g, tail, to, scores, routes)
        _ -> {
          let nexts =
            list.filter_map([d, dir.rotate90(d), dir.rotate270(d)], fn(d1) {
              case grid.cell_at(g, point.add(p, d1)) {
                Ok(Cell(p1, v1)) if v1 == "." || v1 == "E" -> {
                  let step_score = case d == d1 {
                    True -> 1
                    False -> 1001
                  }
                  Ok(#(p1, d1, s + step_score, [p, ..r]))
                }
                _ -> Error(Nil)
              }
            })
          let scores1 = dict.insert(scores, #(p, d), s)
          case list.find(nexts, fn(n) { n.0 == to }) {
            Ok(#(p1, d1, s1, r1)) -> {
              let scores2 = dict.insert(scores1, #(p1, d1), s1)
              walk_rec(g, tail, to, scores2, [#(s1, [to, ..r1]), ..routes])
            }
            _ -> walk_rec(g, list.flatten([tail, nexts]), to, scores1, routes)
          }
        }
      }
    }
  }
}
