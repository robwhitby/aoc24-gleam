import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import input

fn parse(in: List(String)) {
  let assert [stock, ..designs] = input.string_parser(in, ", ")
  #(stock, list.flatten(designs))
}

pub fn part1(in: List(String)) {
  let #(stock, designs) = parse(in)
  list.count(count(designs, stock), fn(i) { i != 0 })
}

pub fn part2(in: List(String)) {
  let #(stock, designs) = parse(in)
  count(designs, stock)
  |> int.sum
}

fn count(designs: List(String), stock: List(String)) {
  let cache = dict.from_list([#("", 1)])
  list.fold(designs, #([], cache), fn(acc, d) {
    count_rec(d, stock, acc.1)
    |> pair.map_first(list.prepend(acc.0, _))
  })
  |> pair.first
}

fn count_rec(design: String, stock: List(String), cache: Dict(String, Int)) {
  case dict.get(cache, design) {
    Ok(v) -> #(v, cache)
    _ ->
      list.filter(stock, string.starts_with(design, _))
      |> list.map(fn(s) { string.drop_start(design, string.length(s)) })
      |> list.fold(#(0, cache), fn(acc, d) {
        count_rec(d, stock, acc.1)
        |> pair.map_first(int.add(_, acc.0))
      })
      |> fn(result) { #(result.0, dict.insert(result.1, design, result.0)) }
  }
}
