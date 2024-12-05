import gleam/int
import gleam/list
import gleam/result
import gleam/string
import input

pub fn part1(in: String) -> Int {
  let data = parse(in)

  data.updates
  |> list.filter(fn(u) { list.all(data.rules, passes(u, _)) })
  |> list.map(middle)
  |> int.sum
}

fn middle(l: List(Int)) -> Int {
  list.drop(l, list.length(l) / 2)
  |> list.first
  |> result.unwrap(0)
}

fn passes(update: Update, rule: Rule) -> Bool {
  case list.filter(update, fn(i) { i == rule.0 || i == rule.1 }) {
    [a, b, ..] -> #(a, b) == rule
    [] -> True
    [_] -> True
  }
}

type Rule =
  #(Int, Int)

type Update =
  List(Int)

type Input {
  Input(rules: List(Rule), updates: List(Update))
}

fn parse(in: String) -> Input {
  let lines = string.split(in, "\n")
  let rules =
    lines
    |> list.filter(string.contains(_, "|"))
    |> list.map(input.ints("|"))
    |> list.map(fn(ints) {
      let assert [a, b] = ints
      #(a, b)
    })

  let updates =
    lines
    |> list.filter(string.contains(_, ","))
    |> list.map(input.ints(","))

  Input(rules, updates)
}
