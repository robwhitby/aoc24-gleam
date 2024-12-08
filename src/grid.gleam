import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/yielder.{type Yielder}
import point.{type Point, Point}

pub type Cells(a) =
  Dict(Point, a)

pub type Cell(a) {
  Cell(point: Point, value: a)
}

pub type Grid(a) {
  Grid(cells: Cells(a), width: Int, height: Int)
}

pub fn cell(grid: Grid(a), point: Point) -> Result(Cell(a), Nil) {
  dict.get(grid.cells, point) |> result.map(Cell(point, _))
}

pub fn contains(grid: Grid(a), point: Point) -> Bool {
  dict.has_key(grid.cells, point)
}

pub fn update(grid: Grid(a), cell: Cell(a)) -> Grid(a) {
  Grid(dict.insert(grid.cells, cell.point, cell.value), grid.width, grid.height)
}

pub fn to_list(grid: Grid(a)) -> List(Cell(a)) {
  grid.cells
  |> dict.to_list
  |> list.map(fn(pair) { Cell(pair.0, pair.1) })
}

pub fn find(
  grid: Grid(a),
  value_predicate: fn(a) -> Bool,
) -> Result(Cell(a), Nil) {
  to_list(grid)
  |> list.find(fn(cell) { value_predicate(cell.value) })
}

pub fn filter(grid: Grid(a), value_predicate: fn(a) -> Bool) -> List(Cell(a)) {
  to_list(grid)
  |> list.filter(fn(cell) { value_predicate(cell.value) })
}

pub fn from_list(in: List(List(a))) -> Grid(a) {
  let cells =
    list.index_map(in, fn(row, y) {
      list.index_map(row, fn(v, x) { #(Point(x, y), v) })
    })
    |> list.flatten
    |> dict.from_list
  let w = in |> list.first |> result.map(list.length) |> result.unwrap(0)
  Grid(cells, w, list.length(in))
}

pub fn line(grid: Grid(a), from: Point, step: Point) -> Yielder(Cell(a)) {
  yielder.iterate(from, point.add(_, step))
  |> yielder.take_while(contains(grid, _))
  |> yielder.filter_map(cell(grid, _))
}

pub fn lines(
  grid: Grid(a),
  from: Point,
  steps: List(Point),
) -> List(Yielder(Cell(a))) {
  list.map(steps, line(grid, from, _))
}
