import dir
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

  let g = grid.update(g, Cell(start.point, "."))

  #(g, start.point, moves)
}

pub fn part1(in: List(String)) -> Int {
  let #(g, start, moves) = parse(in)
  move(g, start, moves)
  |> score
}

pub fn part2(in: List(String)) -> Int {
  let #(g, start, moves) = parse(double_width(in))
  move(g, start, moves)
  |> score
}

fn move(g: Grid(String), from: Point, moves: List(Point)) {
  case moves {
    [] -> g
    [d, ..tail] -> {
      let assert Ok(target) = grid.cell_at(g, point.add(from, d))
      case target {
        Cell(_, "#") -> move(g, from, tail)
        Cell(p, "[") | Cell(p, "]") if d == dir.n || d == dir.s -> {
          case push_double(g, target, d) {
            Ok(g1) -> move(g1, p, tail)
            _ -> move(g, from, tail)
          }
        }
        Cell(p, "[") | Cell(p, "]") | Cell(p, "O") ->
          case push_single(g, p, d) {
            Ok(g1) -> move(g1, p, tail)
            _ -> move(g, from, tail)
          }
        Cell(p, _) -> move(g, p, tail)
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
      Ok(grid.shift_values(g, line, d, "."))
    }
    _ -> Error(Nil)
  }
}

fn push_double(g: Grid(String), from: Cell(String), d: Point) {
  let box = expand_boxes([from])
  let cells = pushable(g, box, d, box)
  case cells {
    [] -> Error(Nil)
    cs -> {
      grid.shift_values(g, list.flatten([cs, box]), d, ".")
      |> list.fold(box, _, fn(g1, c) { grid.update(g1, Cell(c.point, ".")) })
      |> Ok
    }
  }
}

fn pushable(
  g: Grid(String),
  row: List(Cell(String)),
  d: Point,
  acc: List(Cell(String)),
) {
  let next =
    list.filter_map(row, fn(c) { grid.cell_at(g, point.add(c.point, d)) })
  let boxes = expand_boxes(next)
  let hit_wall = list.any(next, is_wall)
  case hit_wall, boxes {
    True, _ -> []
    False, [] -> acc
    False, _ -> pushable(g, boxes, d, list.flatten([acc, boxes]))
  }
}

fn expand_boxes(cells: List(Cell(String))) {
  list.flat_map(cells, fn(c) {
    case c {
      Cell(p, "[") -> [c, Cell(point.add(p, dir.e), "]")]
      Cell(p, "]") -> [c, Cell(point.add(p, dir.w), "[")]
      _ -> []
    }
  })
  |> list.unique
}

fn is_box(c: Cell(String)) {
  list.contains(["O", "[", "]"], c.value)
}

fn is_wall(c: Cell(String)) {
  c.value == "#"
}

fn score(g: Grid(String)) {
  grid.filter(g, fn(v) { v == "O" || v == "[" })
  |> list.map(fn(c) { { c.point.y * 100 } + c.point.x })
  |> int.sum
}

fn double_width(in: List(String)) {
  list.map(in, fn(line) {
    line
    |> string.replace("#", "##")
    |> string.replace("O", "[]")
    |> string.replace(".", "..")
    |> string.replace("@", "@.")
  })
}
