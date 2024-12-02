import aoc24
import day01
import day02
import gleam/io
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

fn print(answer: anything, day: String) {
  io.print_error(day <> ": ")
  io.debug(answer)
}

pub fn day01_part1_test() {
  day01.part1(aoc24.read_as_ints("day01_ex.txt")) |> should.equal(11)
  day01.part1(aoc24.read_as_ints("day01.txt")) |> print("01/1")
}

pub fn day01_part2_test() {
  day01.part2(aoc24.read_as_ints("day01_ex.txt")) |> should.equal(31)
  day01.part2(aoc24.read_as_ints("day01.txt")) |> print("01/2")
}

pub fn day02_part1_test() {
  day02.part1(aoc24.read_as_ints("day02_ex.txt")) |> should.equal(2)
  day02.part1(aoc24.read_as_ints("day02.txt")) |> print("02/1")
}

pub fn day02_part2_test() {
  day02.part2(aoc24.read_as_ints("day02_ex.txt")) |> should.equal(4)
  day02.part2(aoc24.read_as_ints("day02.txt")) |> print("02/2")
}
