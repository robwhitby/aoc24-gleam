import gleam/int
import gleam/list
import gleam/string
import listx
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
  |> listx.filter_not(string.is_empty)
  |> list.map(parser)
}

pub fn strings(delim: String) -> fn(String) -> List(String) {
  parser(_, delim, Ok)
}

pub fn ints(delim: String) -> fn(String) -> List(Int) {
  fn(s) { string.replace(s, ":", "") |> parser(delim, int.parse) }
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
  |> listx.filter_not(string.is_empty)
}
