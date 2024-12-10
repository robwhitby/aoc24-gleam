import gleam/int
import gleam/list
import gleam/string.{concat}
import listx
import simplifile

pub fn read(name: String) -> List(String) {
  let path = concat(["./inputs/day", name <> ".txt"])
  case simplifile.read(path) {
    Ok(content) -> {
      string.split(content, "\n")
      |> listx.filter_not(string.is_empty)
    }
    Error(_) -> panic as string.concat(["error reading ", path])
  }
}

pub fn string_parser(lines: List(String), delim: String) -> List(List(String)) {
  parser(lines, delim, Ok)
}

pub fn int_parser(lines: List(String), delim: String) -> List(List(Int)) {
  let f = fn(s) { string.replace(s, ":", "") |> int.parse }
  parser(lines, delim, f)
}

fn parser(
  lines: List(String),
  delim: String,
  f: fn(String) -> Result(a, Nil),
) -> List(List(a)) {
  lines
  |> list.map(fn(line) {
    line
    |> split(delim)
    |> list.filter_map(f)
  })
}

fn split(in: String, delim: String) -> List(String) {
  case delim {
    "" -> string.to_graphemes(in)
    _ -> string.split(in, delim)
  }
  |> listx.filter_not(string.is_empty)
}
