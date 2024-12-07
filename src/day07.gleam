import gleam/int
import gleam/list
import gleam/result
import input.{type InputInts}

pub fn part1(input: InputInts) -> Int {
  calc(input, [int.add, int.multiply])
}

pub fn part2(input: InputInts) -> Int {
  let ops = [
    int.add,
    int.multiply,
    fn(i, j) {
      result.unwrap(int.parse(int.to_string(i) <> int.to_string(j)), 0)
    },
  ]
  calc(input, ops)
}

fn calc(input, ops) {
  input
  |> list.filter(possible(_, ops))
  |> list.filter_map(list.first)
  |> int.sum
}

fn possible(row: List(Int), ops: List(fn(Int, Int) -> Int)) -> Bool {
  case row {
    [answer, value] -> answer == value
    [answer, i, j, ..tail] -> {
      list.any(ops, fn(op) { possible([answer, op(i, j), ..tail], ops) })
    }
    _ -> False
  }
}
