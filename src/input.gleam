import gleam/int
import gleam/list
import gleam/string
import simplifile

pub type InputStrings =
  List(List(String))

pub type InputInts =
  List(List(Int))

pub fn read(filename) -> String {
  let path = "./inputs/" <> filename
  let assert Ok(content) = simplifile.read(path)
  content
}

pub fn read_lines(filename: String, parser: fn(String) -> a) -> List(a) {
  read(filename)
  |> string.split("\n")
  |> list.filter(fn(line) { !string.is_empty(line) })
  |> list.map(parser)
}

pub fn strings(delim: String) -> fn(String) -> List(String) {
  parser(_, delim, Ok)
}

pub fn ints(delim: String) -> fn(String) -> List(Int) {
  parser(_, delim, int.parse)
}

fn parser(
  line: String,
  delim: String,
  f: fn(String) -> Result(a, Nil),
) -> List(a) {
  line |> split(delim) |> list.filter_map(f)
}

fn split(in: String, delim: String) -> List(String) {
  case delim {
    "" -> string.to_graphemes(in)
    _ -> string.split(in, delim)
  }
  |> list.filter(fn(s) { !string.is_empty(s) })
}
