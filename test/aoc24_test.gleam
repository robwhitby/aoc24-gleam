import day01
import day02
import day03
import day04
import gleam/io
import gleeunit
import gleeunit/should
import input

pub fn main() {
  gleeunit.main()
}

fn print(answer: anything, day: String) {
  io.print_error(day <> ": ")
  io.debug(answer)
}

pub fn day01_part1_test() {
  day01.part1(input.read_as_ints("day01_ex.txt", " ")) |> should.equal(11)
  day01.part1(input.read_as_ints("day01.txt", " ")) |> print("01/1")
}

pub fn day01_part2_test() {
  day01.part2(input.read_as_ints("day01_ex.txt", " ")) |> should.equal(31)
  day01.part2(input.read_as_ints("day01.txt", " ")) |> print("01/2")
}

pub fn day02_part1_test() {
  day02.part1(input.read_as_ints("day02_ex.txt", " ")) |> should.equal(2)
  day02.part1(input.read_as_ints("day02.txt", " ")) |> print("02/1")
}

pub fn day02_part2_test() {
  day02.part2(input.read_as_ints("day02_ex.txt", " ")) |> should.equal(4)
  day02.part2(input.read_as_ints("day02.txt", " ")) |> print("02/2")
}

pub fn day03_part1_test() {
  day03.part1(input.read("day03_ex.txt")) |> should.equal(161)
  day03.part1(input.read("day03.txt")) |> print("03/1")
}

pub fn day03_part2_test() {
  day03.part2(input.read("day03_ex2.txt")) |> should.equal(48)
  day03.part2(input.read("day03.txt")) |> print("03/2")
}

pub fn day04_part1_test() {
  day04.part1(input.read_as_strings("day04_ex.txt", "")) |> should.equal(18)
  day04.part1(input.read_as_strings("day04.txt", "")) |> print("04/1")
}

pub fn day04_part2_test() {
  day04.part2(input.read_as_strings("day04_ex.txt", "")) |> should.equal(9)
  day04.part2(input.read_as_strings("day04.txt", "")) |> print("04/2")
}
