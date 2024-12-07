import dir.{type Dir}
import gleam/list
import gleam/result
import gleam/set.{type Set}
import grid.{type Cell, type Grid, Cell}
import input.{type InputStrings}
import listx

pub fn part1(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  let assert Ok(start) = grid.find(g, list.contains(arrows, _))

  walk(g, start, to_dir(start.value), set.new())
  |> result.map(set.map(_, fn(pair) { pair.0 }))
  |> result.map(set.size)
  |> result.unwrap(0)
}

pub fn part2(input: InputStrings) -> Int {
  let g = grid.from_list(input)
  let assert Ok(start) = grid.find(g, list.contains(arrows, _))

  walk(g, start, to_dir(start.value), set.new())
  |> result.map(set.map(_, fn(pair) { pair.0 }))
  |> result.map(set.to_list)
  |> result.unwrap([])
  |> list.filter(fn(cell) { cell.value == "." })
  |> listx.pmap(fn(cell) {
    grid.update(g, Cell(cell.point, "#"))
    |> walk(start, to_dir(start.value), set.new())
    |> result.is_error
  })
  |> list.count(fn(x) { x == Ok(True) })
}

pub fn walk(
  g: Grid(String),
  pos: Cell(String),
  d: Dir,
  visited: Set(#(Cell(String), Dir)),
) {
  let next = grid.cell(g, grid.move(pos.point, d))
  let v1 = set.insert(visited, #(pos, d))
  case next {
    Ok(Cell(_, "#")) -> walk(g, pos, dir.rotate90(d), v1)
    Ok(Cell(_, _) as cell) ->
      case set.contains(visited, #(cell, d)) {
        True -> Error("loop")
        False -> walk(g, cell, d, v1)
      }
    _ -> Ok(v1)
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
