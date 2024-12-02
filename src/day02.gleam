import aoc24.{type InputInts}
import gleam/int
import gleam/list

pub fn part1(input: InputInts) -> Int {
  input
  |> list.filter(safe)
  |> list.length
}

fn safe(row: List(Int)) -> Bool {
  let ordered = fn(row: List(Int)) -> Bool {
    let sorted = list.sort(row, int.compare)
    row == sorted || list.reverse(row) == sorted
  }

  let valid_diffs = fn(row: List(Int)) -> Bool {
    row
    |> list.window_by_2
    |> list.all(fn(pair: #(Int, Int)) -> Bool {
      let diff = int.absolute_value(pair.0 - pair.1)
      diff >= 1 && diff <= 3
    })
  }

  ordered(row) && valid_diffs(row)
}

pub fn part2(input: InputInts) -> Int {
  let safe_combination = fn(row: List(Int)) -> Bool {
    list.combinations(row, list.length(row) - 1)
    |> list.any(safe)
  }

  input
  |> list.filter(safe_combination)
  |> list.length
}
