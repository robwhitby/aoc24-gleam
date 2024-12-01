import aoc24.{type InputInts}
import gleam/int
import gleam/list

pub fn part1(input: InputInts) -> Int {
  let left = input |> list.filter_map(list.first) |> list.sort(int.compare)
  let right = input |> list.filter_map(list.last) |> list.sort(int.compare)
  list.map2(left, right, fn(l, r) { int.absolute_value(l - r) })
  |> int.sum
}

pub fn part2(input: InputInts) -> Int {
  let left = input |> list.filter_map(list.first)  
  let right = input |> list.filter_map(list.last)
  list.map(left, fn(l) { 
    l * list.count(right, fn(r) { r == l })
  })
  |> int.sum
}
