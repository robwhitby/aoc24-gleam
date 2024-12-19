import gleam/list
import gleam/string
import input

fn parse(in: List(String)) {
  let assert [stock, ..designs] = input.string_parser(in, ", ")
  #(stock, designs)
}

pub fn part1(in: List(String)) {
  let #(stock, designs) = parse(in)
  list.count(designs, possible(_, stock))
}

fn possible(designs: List(String), stock: List(String)) {
  case designs {
    [] -> False
    [d, ..tail] -> {
      let next =
        stock
        |> list.filter(string.starts_with(d, _))
        |> list.map(fn(s) { string.drop_start(d, string.length(s)) })
      case list.contains(next, ""), next {
        True, _ -> True
        _, [] -> possible(tail, stock)
        _, n -> possible(list.unique(list.flatten([tail, n])), stock)
      }
    }
  }
}

pub fn part2(_in: List(String)) {
  0
}
