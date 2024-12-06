import dir
import gleam/dict
import gleam/function
import gleam/list
import gleam/set
import gleeunit/should
import grid.{type Cell, Cell}

pub fn grid_test() {
  let g = grid.from_list([[1, 2], [3, 4]])
  grid.value(g, #(0, 0)) |> should.equal(Ok(1))
  grid.value(g, #(1, 0)) |> should.equal(Ok(2))
  grid.value(g, #(0, 1)) |> should.equal(Ok(3))
  grid.value(g, #(1, 1)) |> should.equal(Ok(4))

  grid.value(g, #(5, 0)) |> should.equal(Error(Nil))

  dict.size(g.cells) |> should.equal(4)
}

pub fn find_test() {
  let g = grid.from_list([[1, 2], [3, 4], [5, 6]])
  grid.find(g, fn(i) { i == 3 })
  |> should.equal(Ok(Cell(#(0, 1), 3)))
}

pub fn grid_lines_test() {
  let g = grid.from_list([[1, 2], [3, 4], [5, 6]])
  grid.lines(g, dir.all)
  |> list.map(grid.line_value(_, function.identity))
  |> set.from_list
  |> should.equal(
    set.from_list([
      [1, 2],
      [1, 3, 5],
      [1, 4],
      [2, 1],
      [2, 3],
      [2, 4, 6],
      [3, 2],
      [3, 4],
      [3, 6],
      [4, 1],
      [4, 3],
      [4, 5],
      [5, 3, 1],
      [5, 4],
      [5, 6],
      [6, 3],
      [6, 4, 2],
      [6, 5],
    ]),
  )
}

pub fn find_in_line_test() {
  let g = grid.from_list([[1, 2, 3, 4, 2, 3, 5]])
  let assert [line] = grid.lines(g, [dir.e])

  grid.find_in_line(line, [2, 3])
  |> should.equal([
    [Cell(#(1, 0), 2), Cell(#(2, 0), 3)],
    [Cell(#(4, 0), 2), Cell(#(5, 0), 3)],
  ])
}
