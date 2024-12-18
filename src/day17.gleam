import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import input

fn parse(in: List(String)) {
  let assert [[a], [b], [c], program] = input.int_parser(in, False)
  let program_dict =
    list.index_map(program, fn(v, i) { #(i, v) })
    |> dict.from_list

  #(State(a, b, c, 0, []), program, program_dict)
}

pub fn part1(in: List(String)) {
  let #(start_state, _, program_dict) = parse(in)

  iterate(start_state, program_dict).out
  |> list.reverse
  |> list.map(int.to_string)
  |> string.join(",")
}

type State {
  State(a: Int, b: Int, c: Int, i: Int, out: List(Int))
}

fn iterate(state: State, program: Dict(Int, Int)) {
  case dict.get(program, state.i), dict.get(program, state.i + 1) {
    Ok(a), Ok(b) -> iterate(instruction(state, a, b), program)
    _, _ -> state
  }
}

fn instruction(s: State, op: Int, v: Int) {
  let combo = fn(op: Int) {
    case op {
      4 -> s.a
      5 -> s.b
      6 -> s.c
      _ -> op
    }
  }

  let adv = fn() {
    int.power(2, int.to_float(combo(v)))
    |> result.try(float.divide(int.to_float(s.a), _))
    |> result.map(float.truncate)
    |> result.unwrap(0)
  }

  case op {
    0 -> State(..s, a: adv(), i: s.i + 2)
    1 -> State(..s, b: int.bitwise_exclusive_or(s.b, v), i: s.i + 2)
    2 -> State(..s, b: combo(v) % 8, i: s.i + 2)
    3 ->
      case s.a {
        0 -> State(..s, i: s.i + 2)
        _ -> State(..s, i: v)
      }
    4 -> State(..s, b: int.bitwise_exclusive_or(s.b, s.c), i: s.i + 2)
    5 -> State(..s, i: s.i + 2, out: [combo(v) % 8, ..s.out])
    6 -> State(..s, b: adv(), i: s.i + 2)
    7 -> State(..s, c: adv(), i: s.i + 2)
    _ -> panic
  }
}

//with help from https://github.com/mgkoning/advent-of-code-2024/blob/main/advent_gleam/src/day17.gleam
pub fn part2(in: List(String)) {
  let #(start_state, program, get_program) = parse(in)
  list.reverse(program)
  |> list.fold([0], fn(possibles, next) {
    possibles
    |> list.flat_map(fn(v) {
      list.range(0, 7)
      |> list.map(fn(i) { 8 * v + i })
      |> list.filter(fn(a) {
        let s = iterate(State(..start_state, a: a), get_program)
        list.last(s.out) == Ok(next)
      })
    })
  })
  |> list.sort(int.compare)
  |> list.first()
  |> result.unwrap(0)
}
