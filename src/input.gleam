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

pub fn read_as_strings(filename, delim) -> InputStrings {
  read(filename)
  |> string.split("\n")
  |> list.map(split(_, delim))
  |> list.filter(fn(row) { !list.is_empty(row) })
}

fn split(in: String, delim: String) -> List(String) {
  case delim {
    "" -> string.to_graphemes(in)
    _ -> string.split(in, delim)
  }
  |> list.filter(fn(s) { !string.is_empty(s) })
}

pub fn read_as_ints(filename, delim) -> InputInts {
  read_as_strings(filename, delim)
  |> list.map(list.filter_map(_, int.parse))
}
