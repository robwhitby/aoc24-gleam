import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import input

fn parse(in: List(String)) {
  let assert [[a], [b], [c], program] = input.int_parser(in, False)
  let program_dict =
    list.index_map(program, fn(v, i) { #(i, v) })
    |> dict.from_list

  let get_program = fn(i: Int) {
    case dict.get(program_dict, i), dict.get(program_dict, i + 1) {
      Ok(a), Ok(b) -> Ok(#(a, b))
      _, _ -> Error(Nil)
    }
  }

  #(State(a, b, c, 0, []), program, get_program)
}

pub fn part1(in: List(String)) {
  let #(start_state, _, get_program) = parse(in)

  let assert Ok(state) = iterate(start_state, get_program)
  list.reverse(state.o)
  |> list.map(int.to_string)
  |> string.concat
  |> int.parse
  |> result.unwrap(0)
}

type State {
  State(a: Int, b: Int, c: Int, i: Int, o: List(Int))
}

fn iterate(state: State, get_program: fn(Int) -> Result(#(Int, Int), Nil)) {
  let instructions = get_instructions()
  yielder.iterate(Ok(state), fn(state: Result(State, Nil)) {
    case state {
      Ok(s) -> {
        case get_program(s.i) {
          Ok(#(a, b)) -> Ok(instructions(a)(s, b))
          _ -> Error(Nil)
        }
      }
      _ -> state
    }
  })
  |> yielder.take_while(result.is_ok)
  |> yielder.last()
  |> result.flatten
}

fn combo(state: State, operand: Int) {
  case operand {
    4 -> state.a
    5 -> state.b
    6 -> state.c
    _ -> operand
  }
}

fn adv(s: State, v: Int) {
  int.power(2, int.to_float(combo(s, v)))
  |> result.try(float.divide(int.to_float(s.a), _))
  |> result.map(float.truncate)
  |> result.unwrap(0)
}

fn get_instructions() {
  [
    #(0, fn(s: State, v: Int) { State(..s, a: adv(s, v), i: s.i + 2) }),
    #(1, fn(s: State, v: Int) {
      State(..s, b: int.bitwise_exclusive_or(s.b, v), i: s.i + 2)
    }),
    #(2, fn(s: State, v: Int) { State(..s, b: combo(s, v) % 8, i: s.i + 2) }),
    #(3, fn(s: State, v: Int) {
      case s.a {
        0 -> State(..s, i: s.i + 2)
        _ -> State(..s, i: v)
      }
    }),
    #(4, fn(s: State, _: Int) {
      State(..s, b: int.bitwise_exclusive_or(s.b, s.c), i: s.i + 2)
    }),
    #(5, fn(s: State, v: Int) {
      State(..s, i: s.i + 2, o: [combo(s, v) % 8, ..s.o])
    }),
    #(6, fn(s: State, v: Int) { State(..s, b: adv(s, v), i: s.i + 2) }),
    #(7, fn(s: State, v: Int) { State(..s, c: adv(s, v), i: s.i + 2) }),
  ]
  |> dict.from_list
  |> fn(d) {
    fn(i: Int) {
      let assert Ok(value) = dict.get(d, i)
      value
    }
  }
}

pub fn part2(in: List(String)) {
  let #(start_state, program, get_program) = parse(in)
  let want = list.reverse(program)

  yielder.iterate(0, fn(n) { n + 2 })
  |> yielder.take_while(fn(i) {
    let s = State(..start_state, a: i)
    case iterate(s, get_program) {
      Ok(s1) -> s1.o != want
      _ -> False
    }
  })
  |> yielder.last()
  |> result.unwrap(-1)
  |> int.add(2)
}
