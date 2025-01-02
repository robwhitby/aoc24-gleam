import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}
import gleam/string
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

  list.map(codes, fn(code) {
    string.to_graphemes(code)
    |> list.fold(#("A", ""), fn(acc, c) {
      #(c, acc.1 <> press(numeric, acc.0, c))
    })
    |> fn(p) {
      let assert Ok(n) = string.drop_end(code, 1) |> int.parse
      #(p.1, n)
    }
  })
  |> list.map(fn(p) { p.1 * keypresses(p.0, directional, n, dict.new()).0 })
  |> int.sum
}

fn keypresses(
  keys: String,
  keypad: Dict(String, Point),
  n: Int,
  cache: Dict(#(String, Int), Int),
) -> #(Int, Dict(#(String, Int), Int)) {
  case dict.get(cache, #(keys, n)) {
    Ok(v) -> #(v, cache)
    _ -> {
      case n {
        0 -> #(string.length(keys), cache)
        _ -> {
          string.to_graphemes(keys)
          |> list.fold(#("A", 0, cache), fn(acc, c) {
            let ks = press(keypad, acc.0, c)
            let #(v, cache2) = keypresses(ks, keypad, n - 1, acc.2)
            #(c, acc.1 + v, dict.insert(cache2, #(ks, n - 1), v))
          })
          |> fn(triple) { #(triple.1, triple.2) }
        }
      }
    }
  }
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
  |> string.append("A")
}
