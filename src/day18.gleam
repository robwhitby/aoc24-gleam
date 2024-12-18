import dir
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/set.{type Set}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let points =
    input.int_parser(in, False)
    |> list.map(fn(line) {
      let assert [a, b] = line
      Point(a, b)
    })
  let is_example = list.length(points) < 1024
  case is_example {
    True -> #(points, 7, 12)
    False -> #(points, 71, 1024)
  }
}

pub fn part1(in: List(String)) -> Int {
  let #(points, size, time) = parse(in)
  let grid = list.take(points, time) |> set.from_list

  walk(grid, size, [#(Point(0, 0), 0)], dict.new())
  |> result.unwrap(-1)
}

pub fn part2(_in: List(String)) -> Int {
  0
}

fn walk(
  grid: Set(Point),
  size: Int,
  from: List(#(Point, Int)),
  visited: Dict(Point, Int),
) {
  let already_visited = fn(p, v) {
    dict.get(visited, p) |> result.map(fn(x) { x <= v }) == Ok(True)
  }
  let next = fn(p: Point, score: Int) {
    list.map(dir.nesw, point.add(p, _))
    |> list.filter(fn(p) {
      p.x >= 0 && p.x < size && p.y >= 0 && p.y < size && !set.contains(grid, p)
    })
    |> list.map(fn(p) { #(p, score + 1) })
  }
  case from {
    [] -> dict.get(visited, Point(size - 1, size - 1))
    [#(p, score), ..tail] -> {
      case already_visited(p, score) {
        True -> walk(grid, size, tail, visited)
        False -> {
          walk(
            grid,
            size,
            list.flatten([tail, next(p, score)]),
            dict.insert(visited, p, score),
          )
        }
      }
    }
  }
}
