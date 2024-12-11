import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import input

fn parse(in: List(String)) {
  input.int_parser(in, " ")
  |> list.first
  |> result.unwrap([])
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> blink(25)
  |> list.length
}

pub fn part2(in: List(String)) -> Int {
  -1
}

fn blink(stones: List(Int), count: Int) -> List(Int) {
  list.range(1, count)
  |> list.fold(stones, fn(acc, _) { list.flat_map(acc, update) })
}

fn update(stone: Int) -> List(Int) {
  let digits = int.to_string(stone) |> string.to_graphemes
  let len = list.length(digits)
  case stone {
    0 -> [1]
    _ if len % 2 == 0 -> {
      list.sized_chunk(digits, len / 2)
      |> list.map(string.concat)
      |> list.filter_map(int.parse)
    }
    _ -> [stone * 2024]
  }
}
