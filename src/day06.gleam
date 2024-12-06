import dir.{type Dir}
import gleam/io
import gleam/list
import gleam/set
import grid.{type Cell, type Grid, Cell}
import input.{type InputStrings}

pub fn part1(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  let assert Ok(start) = grid.find(g, list.contains(arrows, _))

  walk(g, start, to_dir(start.value), [])
  |> set.from_list
  |> set.size
}

fn walk(
  g: Grid(String),
  start: Cell(String),
  step: Dir,
  visited: List(Cell(String)),
) -> List(Cell(String)) {
  let next = grid.cell(g, grid.move(start.point, step))
  case next {
    Ok(Cell(_, "#")) -> walk(g, start, dir.rotate90(step), visited)
    Ok(Cell(_, _) as c) -> walk(g, c, step, [start, ..visited])
    _ -> [start, ..visited]
  }
}

const arrows = ["^", "v", ">", "<"]

fn to_dir(arrow: String) -> dir.Dir {
  case arrow {
    "^" -> dir.n
    ">" -> dir.e
    "v" -> dir.s
    _ -> dir.w
  }
}
