import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  let wires =
    list.filter(in, string.contains(_, ":"))
    |> list.map(fn(line) {
      let assert [wire, value] = string.split(line, ": ")
      #(wire, value == "1")
    })
    |> dict.from_list

  let gates =
    list.filter(in, string.contains(_, "->"))
    |> list.map(fn(line) {
      case string.split(line, " ") {
        [a, "AND", b, _, out] -> Gate(a, bool.and, b, out)
        [a, "OR", b, _, out] -> Gate(a, bool.or, b, out)
        [a, "XOR", b, _, out] -> Gate(a, bool.exclusive_or, b, out)
        _ -> panic
      }
    })

  #(wires, gates)
}

type Gate {
  Gate(a: String, f: fn(Bool, Bool) -> Bool, b: String, out: String)
}

pub fn part1(in: List(String)) {
  let #(wires, gates) = parse(in)

  run(wires, gates)
  |> output
}

fn run(wires: Dict(String, Bool), gates: List(Gate)) {
  case gates {
    [] -> wires
    [g, ..tail] ->
      case apply(wires, g) {
        Ok(w) -> run(w, tail)
        _ -> run(wires, list.flatten([tail, [g]]))
      }
  }
}

fn apply(wires: Dict(String, Bool), gate: Gate) {
  case dict.get(wires, gate.a), dict.get(wires, gate.b) {
    Ok(x), Ok(y) -> Ok(dict.insert(wires, gate.out, gate.f(x, y)))
    _, _ -> Error(Nil)
  }
}

fn output(wires: Dict(String, Bool)) {
  wires
  |> dict.filter(fn(k, _) { string.starts_with(k, "z") })
  |> dict.to_list
  |> list.sort(fn(a, b) { string.compare(b.0, a.0) })
  |> list.map(fn(pair) { bool.to_int(pair.1) |> int.to_string })
  |> string.concat
  |> int.base_parse(2)
  |> result.unwrap(0)
}

pub fn part2(in: List(String)) {
  let #(_, gates) = parse(in)

  let assert Ok(zmax) =
    list.map(gates, fn(g) { g.out })
    |> list.sort(string.compare)
    |> list.last

  gates
  |> list.filter_map(fn(g) {
    let xor = g.f == bool.exclusive_or
    let and = g.f == bool.and
    let assert Ok(out0) = string.first(g.out)
    let assert Ok(a0) = string.first(g.a)
    case g {
      _ if out0 == "z" && !xor && g.out != zmax -> Ok(g.out)
      _ if xor && out0 != "z" && a0 != "x" && a0 != "y" -> Ok(g.out)
      _ if and && g.a != "x00" && g.b != "x00" -> {
        list.find(gates, fn(g1) {
          { g1.a == g.out || g1.b == g.out } && g1.f != bool.or
        })
        |> result.replace(g.out)
      }
      _ if xor -> {
        list.find(gates, fn(g1) {
          { g1.a == g.out || g1.b == g.out } && g1.f == bool.or
        })
        |> result.replace(g.out)
      }
      _ -> Error(Nil)
    }
  })
  |> list.sort(string.compare)
  |> list.take(8)
  |> string.join(",")
}
