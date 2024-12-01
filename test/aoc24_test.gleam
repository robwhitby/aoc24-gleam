import aoc24
import day01
import gleam/io
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn day01_part1_test() {
  day01.part1(aoc24.read_as_ints("day01_ex.txt")) |> should.equal(11)
  day01.part1(aoc24.read_as_ints("day01.txt")) |> io.debug
}

pub fn day01_part2_test() {
  day01.part2(aoc24.read_as_ints("day01_ex.txt")) |> should.equal(31)
  day01.part2(aoc24.read_as_ints("day01.txt")) |> io.debug
}
