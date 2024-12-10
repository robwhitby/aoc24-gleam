import gleam/int
import gleam/list
import gleam/result
import gleam/string
import listx

pub fn part1(in: List(String)) -> Int {
  let data = parse(in)
  data.updates
  |> list.filter(fn(u) { list.all(data.rules, passes(u, _)) })
  |> list.map(middle)
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  let data = parse(in)
  data.updates
  |> list.map(fn(u) { #(u, listx.filter_not(data.rules, passes(u, _))) })
  |> list.filter(fn(p) { !list.is_empty(p.1) })
  |> list.map(fn(p) { sort(p.0, p.1) })
  |> list.map(middle)
  |> int.sum
}

fn sort(update: Update, rules: List(Rule)) -> Update {
  sort_rec([], update, rules)
}

fn sort_rec(sorted: List(Int), update: Update, rules: List(Rule)) -> List(Int) {
  let is_next = fn(existing, n) {
    !list.contains(existing, n)
    && !list.any(rules, fn(r) { r.1 == n && !list.contains(existing, r.0) })
  }

  case list.length(sorted) == list.length(update) {
    True -> sorted
    False -> {
      let assert Ok(x) = list.find(update, is_next(sorted, _))
      sort_rec([x, ..sorted], update, rules)
    }
  }
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

fn parse(in: List(String)) -> Input {
  let rules =
    in
    |> list.filter(string.contains(_, "|"))
    |> list.map(fn(line) {
      string.split(line, "|") |> list.filter_map(int.parse)
    })
    |> list.map(fn(ints) {
      let assert [a, b] = ints
      #(a, b)
    })

  let updates =
    in
    |> list.filter(string.contains(_, ","))
    |> list.map(fn(line) {
      string.split(line, ",") |> list.filter_map(int.parse)
    })

  Input(rules, updates)
}
