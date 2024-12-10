import gleam/int.{to_string}
import gleam/list
import gleam/string.{concat}
import gleeunit/should
import input
import simplifile

const output_file = "./answers"

pub type Day {
  Day(number: Int, part1: PartFn, example1: Int, part2: PartFn, example2: Int)
}

pub fn build_tests(days: List(Day)) {
  let _ = simplifile.delete(output_file)
  list.flat_map(days, fn(day) {
    [
      build_part(day, 1, day.part1, day.example1),
      build_part(day, 2, day.part2, day.example2),
    ]
  })
  |> Inparallel
}

fn build_part(day: Day, part: Int, f: PartFn, example: Int) {
  let day_num = string.pad_start(to_string(day.number), 2, "0")
  let title = concat(["Day ", day_num, ".", to_string(part)])
  let func = fn() {
    let data_ex = input.read(day_num <> "_ex")
    f(data_ex) |> should.equal(example)
    let data = input.read(day_num)
    f(data)
    |> fn(v) {
      simplifile.append(output_file, concat([title, ": ", to_string(v), "\n"]))
    }
  }
  Timeout(10, #(title, func))
}

pub fn answers() {
  let assert Ok(content) = simplifile.read(output_file)
  content
  |> string.split("\n")
  |> list.sort(string.compare)
  |> string.join("\n")
}

type PartFn =
  fn(List(String)) -> Int

pub opaque type TestSpec(a) {
  Timeout(Int, #(String, fn() -> a))
}

pub opaque type TestGroup(a) {
  Inparallel(List(TestSpec(a)))
}
