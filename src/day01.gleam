import gleam/int
import gleam/list
import input.{type InputInts}

pub fn part1(in: InputInts) -> Int {
  let left = in |> list.filter_map(list.first) |> list.sort(int.compare)
  let right = in |> list.filter_map(list.last) |> list.sort(int.compare)
  list.map2(left, right, fn(l, r) { int.absolute_value(l - r) })
  |> int.sum
}

pub fn part2(in: InputInts) -> Int {
  let left = in |> list.filter_map(list.first)
  let right = in |> list.filter_map(list.last)
  list.map(left, fn(l) { l * list.count(right, fn(r) { r == l }) })
  |> int.sum
}
