import dir
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
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
  let #(points, grid_size, time) = parse(in)

  walk(list.take(points, time), grid_size)
  |> result.unwrap(0)
}

pub fn part2(in: List(String)) -> Int {
  let #(points, grid_size, time) = parse(in)

  walkable_until(points, grid_size, time)
  |> io.debug
  0
}

fn walkable_until(points: List(Point), grid_size: Int, time: Int) {
  case walk(list.take(points, time), grid_size) {
    Ok(_) -> walkable_until(points, grid_size, time + 1)
    _ -> list.take(points, time) |> list.last
  }
}

fn walk(points: List(Point), size: Int) {
  walk_rec(set.from_list(points), size, [#(Point(0, 0), 0)], dict.new())
}

fn walk_rec(
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
    [#(p, s), ..tail] -> {
      case already_visited(p, s) {
        True -> walk_rec(grid, size, tail, visited)
        False -> {
          walk_rec(
            grid,
            size,
            list.flatten([tail, next(p, s)]),
            dict.insert(visited, p, s),
          )
        }
      }
    }
  }
}
