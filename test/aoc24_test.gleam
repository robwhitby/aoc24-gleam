import day01
import day02
import day03
import day04
import day05
import day06
import day07
import day08
import day09
import day10
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
  input.read_lines("day01_ex.txt", input.ints(" "))
  |> day01.part1
  |> should.equal(11)

  input.read_lines("day01.txt", input.ints(" "))
  |> day01.part1
  |> print("01/1")
}

pub fn day01_part2_test() {
  input.read_lines("day01_ex.txt", input.ints(" "))
  |> day01.part2
  |> should.equal(31)

  input.read_lines("day01.txt", input.ints(" "))
  |> day01.part1
  |> print("01/2")
}

pub fn day02_part1_test() {
  input.read_lines("day02_ex.txt", input.ints(" "))
  |> day02.part1
  |> should.equal(2)

  input.read_lines("day02.txt", input.ints(" "))
  |> day02.part1
  |> print("02/1")
}

pub fn day02_part2_test() {
  input.read_lines("day02_ex.txt", input.ints(" "))
  |> day02.part2
  |> should.equal(4)

  input.read_lines("day02.txt", input.ints(" "))
  |> day02.part2
  |> print("02/2")
}

pub fn day03_part1_test() {
  input.read("day03_ex.txt")
  |> day03.part1()
  |> should.equal(161)

  input.read("day03.txt")
  |> day03.part1
  |> print("03/1")
}

pub fn day03_part2_test() {
  input.read("day03_ex2.txt")
  |> day03.part2
  |> should.equal(48)

  input.read("day03.txt")
  |> day03.part2
  |> print("03/2")
}

pub fn day04_part1_test() {
  input.read_lines("day04_ex.txt", input.strings(""))
  |> day04.part1
  |> should.equal(18)

  input.read_lines("day04.txt", input.strings(""))
  |> day04.part1
  |> print("04/1")
}

pub fn day04_part2_test() {
  input.read_lines("day04_ex.txt", input.strings(""))
  |> day04.part2
  |> should.equal(9)

  input.read_lines("day04.txt", input.strings(""))
  |> day04.part2
  |> print("04/2")
}

pub fn day05_part1_test() {
  input.read("day05_ex.txt")
  |> day05.part1
  |> should.equal(143)

  input.read("day05.txt")
  |> day05.part1
  |> print("05/1")
}

pub fn day05_part2_test() {
  input.read("day05_ex.txt")
  |> day05.part2
  |> should.equal(123)

  input.read("day05.txt")
  |> day05.part2
  |> print("05/2")
}

pub fn day06_part1_test() {
  input.read_lines("day06_ex.txt", input.strings(""))
  |> day06.part1
  |> should.equal(41)

  input.read_lines("day06.txt", input.strings(""))
  |> day06.part1
  |> print("06/1")
}

pub fn day06_part2_test() {
  input.read_lines("day06_ex.txt", input.strings(""))
  |> day06.part2
  |> should.equal(6)

  input.read_lines("day06.txt", input.strings(""))
  |> day06.part2
  |> print("06/2")
}

pub fn day07_part1_test() {
  input.read_lines("day07_ex.txt", input.ints(" "))
  |> day07.part1
  |> should.equal(3749)

  input.read_lines("day07.txt", input.ints(" "))
  |> day07.part1
  |> print("07/1")
}

pub fn day07_part2_test() {
  input.read_lines("day07_ex.txt", input.ints(" "))
  |> day07.part2
  |> should.equal(11_387)

  input.read_lines("day07.txt", input.ints(" "))
  |> day07.part2
  |> print("07/2")
}

pub fn day08_part1_test() {
  input.read_lines("day08_ex.txt", input.strings(""))
  |> day08.part1
  |> should.equal(14)

  input.read_lines("day08.txt", input.strings(""))
  |> day08.part1
  |> print("08/1")
}

pub fn day08_part2_test() {
  input.read_lines("day08_ex.txt", input.strings(""))
  |> day08.part2
  |> should.equal(34)

  input.read_lines("day08.txt", input.strings(""))
  |> day08.part2
  |> print("08/2")
}

pub fn day09_part1_test() {
  input.read("day09_ex.txt")
  |> input.ints("")
  |> day09.part1
  |> should.equal(1928)

  input.read("day09.txt")
  |> input.ints("")
  |> day09.part1
  |> print("09/1")
}

pub fn day09_part2_test() {
  input.read("day09_ex.txt")
  |> input.ints("")
  |> day09.part2
  |> should.equal(2858)

  input.read("day09.txt")
  |> input.ints("")
  |> day09.part2
  |> print("09/2")
}

pub fn day10_part1_test() {
  input.read_lines("day10_ex.txt", input.ints(""))
  |> day10.part1
  |> should.equal(36)

  input.read_lines("day10.txt", input.ints(""))
  |> day10.part1
  |> print("10/1")
}

pub fn day10_part2_test() {
  input.read_lines("day10_ex.txt", input.ints(""))
  |> day10.part2
  |> should.equal(81)

  input.read_lines("day10.txt", input.ints(""))
  |> day10.part2
  |> print("10/2")
}