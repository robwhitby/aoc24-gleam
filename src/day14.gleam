import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import grid.{type Cell, Cell}
import input
import listx
import point.{type Point, Point}

const width = 101

const height = 103

fn parse(in: List(String)) {
  input.int_parser(in, False)
  |> list.map(fn(line) {
    let assert [px, py, vx, vy] = line
    Cell(Point(px, py), Point(vx, vy))
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.map(move(_,100))
  |> list.filter_map(quarter)
  |> listx.count_uniq
  |> dict.values
  |> int.product
}

fn move(c: Cell(Point), steps: Int) {
  let mod = fn(i, j) { int.modulo(i, j) |> result.unwrap(0) }
  let leap = Point(c.value.x * steps, c.value.y * steps)
  let Point(x, y) = point.add(c.point, leap)
  Point(mod(x, width), mod(y, height))
}

fn quarter(p: Point) {
  case int.compare(p.x, width / 2), int.compare(p.y, height / 2) {
    order.Eq, _ | _, order.Eq -> Error("middle")
    a, b -> Ok(#(a, b))
  }
}

pub fn part2(_in: List(String)) -> Int {
  0
}
