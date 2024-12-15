import day.{Day}
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
import day11
import day12
import day13
import day14
import day15
import gleam/io
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn day_test_() {
  let days = [
    Day(1, day01.part1, 11, day01.part2, 31),
    Day(2, day02.part1, 2, day02.part2, 4),
    Day(3, day03.part1, 161, day03.part2, 48),
    Day(4, day04.part1, 18, day04.part2, 9),
    Day(5, day05.part1, 143, day05.part2, 123),
    Day(6, day06.part1, 41, day06.part2, 6),
    Day(7, day07.part1, 3749, day07.part2, 11_387),
    Day(8, day08.part1, 14, day08.part2, 34),
    Day(9, day09.part1, 1928, day09.part2, 2858),
    Day(10, day10.part1, 36, day10.part2, 81),
    Day(11, day11.part1, 55_312, day11.part2, 65_601_038_650_482),
    Day(12, day12.part1, 1930, day12.part2, 1206),
    Day(13, day13.part1, 480, day13.part2, 875_318_608_908),
    Day(14, day14.part1, 21, day14.part2, 101 * 103),
    Day(15, day15.part1, 10_092, day15.part2, 0),
  ]
  day.build_tests(days)
}

pub fn answers_test() {
  io.println_error(day.answers())
}
