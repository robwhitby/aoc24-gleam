import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import listx

fn parse(in: List(String)) {
  list.filter_map(in, string.split_once(_, "-"))
  |> list.map(fn(p) { dict.from_list([#(p.0, [p.1]), #(p.1, [p.0])]) })
  |> list.reduce(fn(acc, d) { dict.combine(acc, d, list.append) })
  |> result.unwrap(dict.new())
}

pub fn part1(in: List(String)) {
  let computers = parse(in)
  computers
  |> dict.keys
  |> list.flat_map(fn(k) {
    dict.get(computers, k)
    |> result.unwrap([])
    |> list.combinations(2)
    |> list.map(fn(l) { list.prepend(l, k) |> list.sort(string.compare) })
  })
  |> list.filter(fn(l) { list.any(l, string.starts_with(_, "t")) })
  |> listx.count_uniq
  |> dict.filter(fn(_, v) { v == 3 })
  |> dict.size
}

pub fn part2(in: List(String)) {
  0
}
