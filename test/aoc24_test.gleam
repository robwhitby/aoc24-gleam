import aoc.{day}
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
import day16
import day17
import day18
import day19
import day20
import day21
import gleam/io
import gleeunit

pub fn main() {
  aoc.init()
  gleeunit.main()
}

pub fn day_test_() {
  let days = [
    // day(1, day01.part1, 11, day01.part2, 31),
    // day(2, day02.part1, 2, day02.part2, 4),
    // day(3, day03.part1, 161, day03.part2, 48),
    // day(4, day04.part1, 18, day04.part2, 9),
    // day(5, day05.part1, 143, day05.part2, 123),
    // day(6, day06.part1, 41, day06.part2, 6),
    // day(7, day07.part1, 3749, day07.part2, 11_387),
    // day(8, day08.part1, 14, day08.part2, 34),
    // day(9, day09.part1, 1928, day09.part2, 2858),
    // day(10, day10.part1, 36, day10.part2, 81),
    // day(11, day11.part1, 55_312, day11.part2, 65_601_038_650_482),
    // day(12, day12.part1, 1930, day12.part2, 1206),
    // day(13, day13.part1, 480, day13.part2, 875_318_608_908),
    // day(14, day14.part1, 21, day14.part2, 101 * 103),
    // day(15, day15.part1, 10_092, day15.part2, 9021),
    // day(16, day16.part1, 7036, day16.part2, 45),
    // day(17, day17.part1, "5,7,3,0", day17.part2, 117_440),
    // day(18, day18.part1, 22, day18.part2, "6,1"),
    //day(19, day19.part1, 6, day19.part2, 16),
    //day(20, day20.part1, 1, day20.part2, 285),
    day(21, day21.part1, 126_384, day21.part2, -1),
  ]
  aoc.build_tests(days)
}

pub fn answers_test() {
  io.println_error(aoc.answers())
}
