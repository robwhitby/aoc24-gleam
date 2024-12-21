import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/pair
import gleam/result
import gleam/string
import listx
import point.{type Point, Point}

fn parse(in: List(String)) {
  let numeric =
    [
      #("9", Point(2, 0)),
      #("8", Point(1, 0)),
      #("7", Point(0, 0)),
      #("6", Point(2, 1)),
      #("5", Point(1, 1)),
      #("4", Point(0, 1)),
      #("3", Point(2, 2)),
      #("2", Point(1, 2)),
      #("1", Point(0, 2)),
      #("A", Point(2, 3)),
      #("0", Point(1, 3)),
      #(" ", Point(0, 3)),
    ]
    |> dict.from_list

  let directional =
    [
      #("A", Point(2, 0)),
      #("^", Point(1, 0)),
      #(" ", Point(0, 0)),
      #(">", Point(2, 1)),
      #("v", Point(1, 1)),
      #("<", Point(0, 1)),
    ]
    |> dict.from_list

  #(in, numeric, directional)
}

pub fn part1(in: List(String)) {
  chain(in, 2)
}

pub fn part2(in: List(String)) {
  chain(in, 25)
}

fn chain(in: List(String), n: Int) {
  let #(codes, numeric, directional) = parse(in)

  listx.pmap(codes, fn(code) {
    let keys = keypresses(code, numeric)
    let len =
      list.range(1, n)
      |> list.fold(keys, fn(acc, _) { keypresses(acc, directional) })
      |> string.length

    let assert Ok(n) = string.drop_end(code, 1) |> int.parse
    len * n
  })
  |> result.values
  |> int.sum
}

fn keypresses(keys: String, keypad: Dict(String, Point)) {
  string.to_graphemes(keys)
  |> list.fold(#("A", ""), fn(acc, c) {
    #(c, string.concat([acc.1, press(keypad, acc.0, c), "A"]))
  })
  |> pair.second
}

pub fn press(keypad: Dict(String, Point), current: String, key: String) {
  let assert [Ok(a), Ok(b)] = [dict.get(keypad, current), dict.get(keypad, key)]
  let assert [xo, yo] = [int.compare(b.x, a.x), int.compare(b.y, a.y)]

  let xs =
    case xo {
      Eq -> ""
      Gt -> ">"
      Lt -> "<"
    }
    |> list.repeat(int.absolute_value(a.x - b.x))

  let ys =
    case yo {
      Eq -> ""
      Gt -> "v"
      Lt -> "^"
    }
    |> list.repeat(int.absolute_value(a.y - b.y))

  let assert Ok(gap) = dict.get(keypad, " ")
  case a, b {
    Point(0, _), _ if b.y == gap.y -> list.flatten([xs, ys])
    _, Point(0, _) if a.y == gap.y -> list.flatten([ys, xs])
    _, _ if xo == Lt -> list.flatten([xs, ys])
    _, _ -> list.flatten([ys, xs])
  }
  |> string.concat
}
