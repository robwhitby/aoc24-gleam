import dir
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
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
          case push_single(g, p, next) {
            Ok(g1) -> move(g1, p, tail)
            _ -> move(g, from, tail)
          }
        Ok(Cell(p, _)) -> move(g, p, tail)
        _ -> g
      }
    }
  }
}

fn push_single(g: Grid(String), from: Point, d: Point) {
  let line =
    grid.line(g, from, d)
    |> yielder.take_while(is_box)
    |> yielder.to_list
  let assert Ok(last) = list.last(line)
  let assert Ok(after) = grid.cell_at(g, point.add(last.point, d))
  case after {
    Cell(_, v) if v != "#" -> {
      Ok(shift_cells(g, [after, ..line], d))
    }
    _ -> Error(Nil)
  }
}

fn shift_cells(g: Grid(String), cells: List(Cell(String)), d: Point) {
  list.map(cells, fn(c) {
    let assert Ok(c1) = grid.cell_at(g, point.subtract(c.point, d))
    #(c.point, c1.value)
  })
  |> dict.from_list
  |> fn(changes) { Grid(dict.merge(g.cells, changes), g.width, g.height) }
}

fn is_box(c: Cell(String)) {
  list.contains(["O", "[", "]"], c.value)
}

fn score(g: Grid(String)) {
  grid.filter(g, fn(v) { v == "O" })
  |> list.map(fn(c) { { c.point.y * 100 } + c.point.x })
  |> int.sum
}
