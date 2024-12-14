import gleam/function
import gleam/pair
import gleam/dict
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
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
  |> list.map(move(_, 100))
  |> list.filter_map(quarter)
  |> listx.count_uniq
  |> dict.values
  |> int.product
}

fn move(c: Cell(Point), steps: Int) {
  let mod = fn(i, j) { int.modulo(i, j) |> result.unwrap(0) }
  let leap = Point(c.value.x * steps, c.value.y * steps)
  let Point(x, y) = point.add(c.point, leap)
  Cell(Point(mod(x, width), mod(y, height)), c.value)
}

fn quarter(c: Cell(a)) {
  case int.compare(c.point.x, width / 2), int.compare(c.point.y, height / 2) {
    order.Eq, _ | _, order.Eq -> Error("middle")
    a, b -> Ok(#(a, b))
  }
}

pub fn part2(in: List(String)) -> Int {
  let start_cells = parse(in)

  list.range(1, width * height)
  |> list.fold_until(#(start_cells, 0), fn(acc, i) {
    let next = list.map(acc.0, move(_, 1))
    case is_tree(next) {
      True -> Stop(#(next, i))
      False -> Continue(#(next, i))
    }
  })
  // |> function.tap(fn(pair) {
  //   grid.from_cells(pair.0, width, height)
  //   |> grid.to_string("#")
  //   |> io.print_error()
  // })
  |> pair.second
}

fn is_tree(cells: List(Cell(a))) {
  let ps = list.map(cells, fn(c) { c.point })

  let all = fn(x1, x2, y) {
    list.range(x1, x2)
    |> list.all(fn(x) { list.contains(ps, Point(x, y)) })
  }

  list.find(ps, fn(p) {
    p.x == width / 2
    && all(p.x - 1, p.x + 1, p.y + 1)
    && all(p.x - 2, p.x + 2, p.y + 2)
  })
  |> result.is_ok
}
