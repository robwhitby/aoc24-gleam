import gleam/int
import gleam/list
import input
import point.{type Point, Point}

fn parse(in: List(String), offset: Int) {
  list.sized_chunk(in, 3)
  |> list.map(fn(lines) {
    let assert [[ax, ay], [bx, by], [cx, cy]] = input.int_parser(lines, False)
    Game(Point(ax, ay), Point(bx, by), Point(cx + offset, cy + offset))
  })
}

type Game {
  Game(button_a: Point, button_b: Point, prize: Point)
}

// (e,f) = (a,b)x + (c,d)y
//
// e = ax + cy
// f = bx + dy
//
// ax + cy - e = 0
// bx + dy - f = 0
//
// x = (de - cf)/(da - cb)
// y = (fa - eb)/(da - cb)
fn solve(g: Game) -> Int {
  let Game(Point(a, b), Point(c, d), Point(e, f)) = g
  let div = { d * a } - { c * b }
  let x = { d * e } - { c * f }
  let y = { f * a } - { e * b }
  case x % div, y % div {
    0, 0 -> { 3 * { x / div } } + { y / div }
    _, _ -> 0
  }
}

pub fn part1(in: List(String)) -> Int {
  parse(in, 0)
  |> list.map(solve)
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  parse(in, 10_000_000_000_000)
  |> list.map(solve)
  |> int.sum
}
