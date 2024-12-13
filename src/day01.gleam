import gleam/int
import gleam/list
import input

fn parse(in: List(String)) {
  input.int_parser(in, False)
}

pub fn part1(in: List(String)) -> Int {
  let data = parse(in)
  let left = data |> list.filter_map(list.first) |> list.sort(int.compare)
  let right = data |> list.filter_map(list.last) |> list.sort(int.compare)
  list.map2(left, right, fn(l, r) { int.absolute_value(l - r) })
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  let data = parse(in)
  let left = data |> list.filter_map(list.first)
  let right = data |> list.filter_map(list.last)
  list.map(left, fn(l) { l * list.count(right, fn(r) { r == l }) })
  |> int.sum
}
