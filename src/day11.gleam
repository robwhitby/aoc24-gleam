import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import input

type Stones =
  Dict(Int, Int)

fn parse(in: List(String)) -> Stones {
  input.int_parser(in, " ")
  |> list.first
  |> result.unwrap([])
  |> list.fold(dict.new(), fn(d, i) { dict.insert(d, i, 1) })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> blink(25)
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> blink(75)
}

fn blink(stones: Stones, times: Int) -> Int {
  list.range(1, times)
  |> list.fold(stones, fn(acc, _) { blink_once(acc) })
  |> dict.values
  |> int.sum
}

fn blink_once(stones: Stones) -> Stones {
  dict.fold(stones, dict.new(), fn(acc, stone, count) {
    list.fold(update(stone), acc, fn(acc2, new_stone) {
      dict.upsert(acc2, new_stone, fn(v) { option.unwrap(v, 0) + count })
    })
  })
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
