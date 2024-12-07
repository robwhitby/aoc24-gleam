import gleam/int
import gleam/list
import gleam/result
import input.{type InputInts}

pub fn part1(input: InputInts) -> Int {
  let ops = [int.add, int.multiply]

  input
  |> list.filter_map(possible(_, ops))
  |> int.sum
}

pub fn part2(input: InputInts) -> Int {
  let ops = [
    int.add,
    int.multiply,
    fn(i, j) {
      result.unwrap(int.parse(int.to_string(i) <> int.to_string(j)), 0)
    },
  ]

  input
  |> list.filter_map(possible(_, ops))
  |> int.sum
}

type Op =
  fn(Int, Int) -> Int

fn possible(row: List(Int), ops: List(Op)) {
  let assert [answer, head, ..tail] = row
  let ok =
    list.fold(tail, [head], fn(results, i) {
      list.flat_map(results, fn(r) { list.map(ops, fn(op) { op(r, i) }) })
    })
    |> list.contains(answer)
  case ok {
    True -> Ok(answer)
    False -> Error("nope")
  }
}
