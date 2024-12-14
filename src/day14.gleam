import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import grid.{type Cell, Cell}
import input
import listx
import point.{type Point, Point}

fn parse(in: List(String)) {
  input.int_parser(in, False)
  |> list.map(fn(line) {
    let assert [px, py, vx, vy] = line
    Cell(Point(px, py), Point(vx, vy))
  })
}

pub fn part1(in: List(String)) -> Int {
  let cells = parse(in)
  let steps = 100
  let width = 101
  let height = 103

  let mod = fn(i, j) { int.modulo(i, j) |> result.unwrap(0) }

  let move = fn(c: Cell(Point)) {
    let leap = Point(c.value.x * steps, c.value.y * steps)
    let Point(x, y) = point.add(c.point, leap)
    Point(mod(x, width), mod(y, height))
  }

  let quarter = fn(p: Point) {
    case int.compare(p.x, width / 2), int.compare(p.y, height / 2) {
      order.Eq, _ | _, order.Eq -> Error("middle")
      a, b -> Ok(#(a, b))
    }
  }

  cells
  |> list.map(move)
  |> list.filter_map(quarter)
  |> listx.count_uniq
  |> dict.values
  |> int.product
}

pub fn part2(_in: List(String)) -> Int {
  0
}
