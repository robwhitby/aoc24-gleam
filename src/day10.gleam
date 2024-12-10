import gleam/list
import grid.{type Cell, type Grid, Cell}
import input.{type InputInts}
import dir
import point

pub fn part1(input: InputInts) -> Int {
  let g = grid.from_list(input)
  grid.filter(g, fn(v) { v == 0 })
  |> list.flat_map(routes(g, _))
  |> list.length
}

pub fn routes(g: Grid(Int), from: Cell(Int)) -> List(Cell(Int)) {
  from.point
  |> point.neighbours(dir.nesw)
  |> list.filter_map(grid.cell(g, _))
  |> list.filter(fn(n) { n.value == from.value + 1 })
  |> list.flat_map(fn(n) {
    case n {
      Cell(_, 9) -> [n]
      Cell(..) -> routes(g, n)
    }
  })
  |> list.unique
}
