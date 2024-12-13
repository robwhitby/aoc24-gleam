import gleam/int
import gleam/list
import input

fn parse(in: List(String)) {
  list.sized_chunk(in, 3)
  |> list.map(fn(game) { input.int_parser(game, False) |> list.flatten })
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
fn solve(game: List(Int), offset: Int) -> Int {
  let assert [a, b, c, d, e, f] = game
  let e = e + offset
  let f = f + offset
  let div = { d * a } - { c * b }
  let x = { d * e } - { c * f }
  let y = { f * a } - { e * b }
  case x % div, y % div {
    0, 0 -> { 3 * { x / div } } + { y / div }
    _, _ -> 0
  }
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.map(solve(_, 0))
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> list.map(solve(_, 10_000_000_000_000))
  |> int.sum
}
