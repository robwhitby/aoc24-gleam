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
  0
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
