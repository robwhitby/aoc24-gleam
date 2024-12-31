import gleam/dict
import gleam/int
import gleam/list
import gleam/result

fn parse(in: List(String)) {
  list.filter_map(in, int.parse)
}

pub fn part1(in: List(String)) {
  parse(in)
  |> list.map(nth_secret(_, 2000))
  |> int.sum
}

pub fn part2(in: List(String)) {
  parse(in)
  |> list.map(seqs)
  |> list.reduce(fn(acc, d) { dict.combine(acc, d, fn(a, b) { a + b }) })
  |> result.map(dict.values(_))
  |> result.try(list.reduce(_, int.max))
  |> result.unwrap(0)
}

fn seqs(secret: Int) {
  list.fold(list.range(1, 2000), [secret], fn(acc, _) {
    [next(list.first(acc) |> result.unwrap(0)), ..acc]
  })
  |> list.map(fn(x) {
    int.digits(x, 10) |> result.try(list.last) |> result.unwrap(0)
  })
  |> list.reverse
  |> list.window_by_2
  |> list.map(fn(pair) { #(pair.1, pair.1 - pair.0) })
  |> list.window(4)
  |> list.map(fn(w) {
    let assert [#(_, i), #(_, j), #(_, k), #(d, l)] = w
    #([i, j, k, l], d)
  })
  |> list.reverse
  |> dict.from_list
}

fn nth_secret(secret: Int, n: Int) {
  case n == 0 {
    True -> secret
    False -> nth_secret(next(secret), n - 1)
  }
}

fn next(secret: Int) {
  let mixnprune = fn(a, f) {
    f(a)
    |> int.bitwise_exclusive_or(a)
    |> int.modulo(16_777_216)
    |> result.unwrap(0)
  }

  secret
  |> mixnprune(int.multiply(_, 64))
  |> mixnprune(fn(i) { i / 32 })
  |> mixnprune(int.multiply(_, 2048))
}
