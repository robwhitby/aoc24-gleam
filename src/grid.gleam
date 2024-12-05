import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleam/set
import gleam/yielder

pub type Point =
  #(Int, Int)

pub type Cells(a) =
  Dict(Point, a)

pub type Grid(a) {
  Grid(cells: Cells(a), width: Int, height: Int)
}

pub fn get(grid: Grid(a), point: Point) -> Result(a, Nil) {
  dict.get(grid.cells, point)
}

pub fn contains(grid: Grid(a), point: Point) -> Bool {
  dict.has_key(grid.cells, point)
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

pub fn lines(grid: Grid(a)) -> List(List(a)) {
  let assert [n, e, s, w] = [#(0, -1), #(1, 0), #(0, 1), #(-1, 0)]
  let assert [ne, nw, se, sw] = [#(1, -1), #(-1, -1), #(1, 1), #(-1, 1)]

  let line = fn(from: Point, step: Point) {
    yielder.iterate(from, fn(p) { #(p.0 + step.0, p.1 + step.1) })
    |> yielder.take_while(contains(grid, _))
  }

  let ls = fn(from: Point, dirs: List(Point)) { list.map(dirs, line(from, _)) }

  let top = line(#(0, 0), e) |> yielder.map(ls(_, [s, sw, se]))
  let left = line(#(0, 0), s) |> yielder.map(ls(_, [e, ne, se]))
  let bottom = line(#(0, grid.height - 1), e) |> yielder.map(ls(_, [n, nw, ne]))
  let right = line(#(grid.width - 1, 0), s) |> yielder.map(ls(_, [w, nw, sw]))

  yielder.concat([top, bottom, left, right])
  |> yielder.to_list
  |> list.flatten
  |> list.map(yielder.to_list)
  |> set.from_list
  |> set.to_list
  |> list.map(list.filter_map(_, get(grid, _)))
  |> list.filter(fn(l) { list.length(l) > 1 })
}
