import dir
import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import gleam/yielder
import grid.{type Cell, type Grid, Cell, Grid}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let g =
    list.take_while(in, string.starts_with(_, "#"))
    |> input.string_parser("")
    |> grid.from_list

  let moves =
    list.drop_while(in, string.starts_with(_, "#"))
    |> string.concat
    |> string.to_graphemes
    |> list.map(fn(c) {
      case c {
        "^" -> dir.n
        ">" -> dir.e
        "v" -> dir.s
        "<" -> dir.w
        _ -> panic
      }
    })

  let assert Ok(start) = grid.find(g, fn(v) { v == "@" })

  #(g, start.point, moves)
}

pub fn part1(in: List(String)) -> Int {
  let #(g, start, moves) = parse(in)
  move(g, start, moves)
  |> score
}

pub fn part2(_in: List(String)) -> Int {
  0
}

fn move(g: Grid(String), from: Point, moves: List(Point)) {
  case moves {
    [] -> g
    [next, ..tail] -> {
      let target = grid.cell_at(g, point.add(from, next))
      case target {
        Ok(Cell(_, v)) if v == "#" -> move(g, from, tail)
        Ok(Cell(p, v)) if v == "O" ->
          case push(g, p, next) {
            Ok(g1) -> move(g1, p, tail)
            _ -> move(g, from, tail)
          }
        Ok(Cell(p, _)) -> move(g, p, tail)
        _ -> g
      }
    }
  }
}

fn push(g: Grid(String), from: Point, move: Point) {
  grid.line(g, from, move)
  |> yielder.drop_while(fn(c) { c.value == "O" })
  |> yielder.first
  |> fn(after) {
    case after {
      Ok(Cell(p, v)) if v != "#" -> {
        let swap = g.cells |> dict.insert(from, ".") |> dict.insert(p, "O")
        Ok(Grid(swap, g.width, g.height))
      }
      _ -> Error(Nil)
    }
  }
}

fn score(g: Grid(String)) {
  grid.filter(g, fn(v) { v == "O" })
  |> list.map(fn(c) { { c.point.y * 100 } + c.point.x })
  |> int.sum
}
