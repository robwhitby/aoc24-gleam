import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  let schemas =
    list.map(in, string.to_graphemes)
    |> list.sized_chunk(7)

  let parse_schemas = fn(in, match) {
    list.filter(in, fn(s) {
      list.first(s) |> result.try(list.first) == Ok(match)
    })
    |> list.map(fn(s) {
      list.transpose(s)
      |> list.map(list.count(_, fn(c) { c == "#" }))
    })
  }

  let locks = parse_schemas(schemas, "#")
  let keys = parse_schemas(schemas, ".")
  #(locks, keys)
}

pub fn part1(in: List(String)) {
  let #(locks, keys) = parse(in)
  locks
  |> list.map(fn(lock) { keys |> list.count(fits(lock, _)) })
  |> int.sum
}

fn fits(lock: List(Int), key: List(Int)) {
  list.map2(lock, key, fn(a, b) { a + b <= 7 })
  |> list.all(function.identity)
}

pub fn part2(_in: List(String)) {
  0
}
