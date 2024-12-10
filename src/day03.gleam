import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  in |> list.first |> result.unwrap("")
}

pub fn part1(in: List(String)) -> Int {
  let data = parse(in)
  let assert Ok(re) = regexp.from_string("(mul\\((\\d+),(\\d+)\\))")
  regexp.scan(re, data)
  |> list.map(fn(match) -> Int {
    let assert [_, option.Some(a), option.Some(b)] = match.submatches
    result.unwrap(int.parse(a), 0) * result.unwrap(int.parse(b), 0)
  })
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  let data = parse(in)
  let assert Ok(re) = regexp.from_string("don't\\(\\).*?do\\(\\)")
  data
  |> string.replace("\n", "")
  |> regexp.replace(re, _, "")
  |> list.wrap
  |> part1
}
