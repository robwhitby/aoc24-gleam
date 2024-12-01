import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type InputStrings =
  List(List(String))

pub type InputInts =
  List(List(Int))

pub fn main() {
  io.println("Hello from aoc24!")
}

pub fn read_as_strings(filename) -> InputStrings {
  let path = "./inputs/" <> filename
  let assert Ok(content) = simplifile.read(path)
  string.split(content, "\n")
  |> list.map(split)
  |> list.filter(fn(row) { !list.is_empty(row) })
}

fn split(in) -> List(String) {
  string.split(in, " ")
  |> list.filter(fn(s) { !string.is_empty(s) })
}

pub fn read_as_ints(filename) -> InputInts {
  read_as_strings(filename)
  |> list.map(strings_to_ints)
}

pub fn strings_to_ints(strings: List(String)) -> List(Int) {
  strings |> list.filter_map(int.parse)
}
