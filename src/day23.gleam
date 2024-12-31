import gleam/dict
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
  find_sets(computers, 3)
  |> list.filter(fn(l) { list.any(l, string.starts_with(_, "t")) })
  |> list.length
}

pub fn part2(in: List(String)) {
  let computers = parse(in)
  largest_set(computers, 20)
  |> result.unwrap([])
  |> string.join(",")
}

fn largest_set(computers, size) {
  case find_sets(computers, size) {
    [head, ..] -> Ok(head)
    [] -> largest_set(computers, size - 1)
  }
}

fn find_sets(computers, size) {
  computers
  |> dict.keys
  |> list.flat_map(fn(k) {
    dict.get(computers, k)
    |> result.unwrap([])
    |> list.combinations(size - 1)
    |> list.map(fn(l) { list.prepend(l, k) |> list.sort(string.compare) })
  })
  |> listx.count_uniq
  |> dict.filter(fn(_, v) { v == size })
  |> dict.keys
}
