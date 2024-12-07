import dir.{type Dir}
import gleam/dict.{type Dict}
import gleam/function
import gleam/list
import gleam/result
import gleam/yielder

pub type Point =
  #(Int, Int)

pub type Cells(a) =
  Dict(Point, a)

pub type Cell(a) {
  Cell(point: Point, value: a)
}

pub type Grid(a) {
  Grid(cells: Cells(a), width: Int, height: Int)
}

pub fn value(grid: Grid(a), point: Point) -> Result(a, Nil) {
  dict.get(grid.cells, point)
}

pub fn cell(grid: Grid(a), point: Point) -> Result(Cell(a), Nil) {
  value(grid, point) |> result.map(Cell(point, _))
}

pub fn contains(grid: Grid(a), point: Point) -> Bool {
  dict.has_key(grid.cells, point)
}

pub fn move(from: Point, step: Point) -> Point {
  #(from.0 + step.0, from.1 + step.1)
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
      list.index_map(row, fn(v, x) { #(#(x, y), v) })
    })
    |> list.flatten
    |> dict.from_list
  let w = in |> list.first |> result.map(list.length) |> result.unwrap(0)
  Grid(cells, w, list.length(in))
}

pub fn line(grid: Grid(a), from: Point, step: Point) {
  yielder.iterate(from, move(_, step))
  |> yielder.take_while(contains(grid, _))
  |> yielder.filter_map(cell(grid, _))
}

pub fn lines(grid: Grid(a), dirs: List(Dir)) -> List(List(Cell(a))) {
  let lines_from = fn(start: Point, d: Dir, ds: List(Dir)) {
    line(grid, start, d)
    |> yielder.map(fn(c: Cell(a)) {
      list.map(list.filter(ds, list.contains(dirs, _)), line(grid, c.point, _))
    })
  }

  let top = lines_from(#(0, 0), dir.e, [dir.s, dir.sw, dir.se])
  let left = lines_from(#(0, 0), dir.s, [dir.e, dir.ne, dir.se])
  let bottom = lines_from(#(0, grid.height - 1), dir.e, [dir.n, dir.nw, dir.ne])
  let right = lines_from(#(grid.width - 1, 0), dir.s, [dir.w, dir.nw, dir.sw])

  yielder.concat([top, bottom, left, right])
  |> yielder.to_list
  |> list.flatten
  |> list.map(yielder.to_list)
  |> list.unique
  |> list.filter(fn(l) { list.length(l) > 1 })
}

pub fn line_value(line: List(Cell(a)), acc: fn(List(a)) -> b) -> b {
  list.map(line, fn(cell) { cell.value })
  |> acc
}

pub fn find_in_line(line: List(Cell(a)), values: List(a)) -> List(List(Cell(a))) {
  let len = list.length(values)
  list.window(line, len)
  |> list.filter(fn(w) { line_value(w, function.identity) == values })
}

pub fn find_in_lines(
  lines: List(List(Cell(a))),
  values: List(a),
) -> List(List(Cell(a))) {
  list.flat_map(lines, find_in_line(_, values))
}

pub fn update(grid: Grid(a), cell: Cell(a)) -> Grid(a) {
  Grid(dict.insert(grid.cells, cell.point, cell.value), grid.width, grid.height)
}
