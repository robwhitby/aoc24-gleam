import gleam/int
import gleam/list
import input

fn parse(in: List(String)) {
  input.int_parser(in, False)
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.count(safe)
}

pub fn part2(in: List(String)) -> Int {
  let safe_combination = fn(row: List(Int)) -> Bool {
    list.combinations(row, list.length(row) - 1)
    |> list.any(safe)
  }

  parse(in)
  |> list.count(safe_combination)
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
