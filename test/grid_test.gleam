import gleam/dict
import gleam/set
import gleeunit/should
import grid

pub fn grid_test() {
  let g = grid.from_list([[1, 2], [3, 4]])
  grid.get(g, #(0, 0)) |> should.equal(Ok(1))
  grid.get(g, #(1, 0)) |> should.equal(Ok(2))
  grid.get(g, #(0, 1)) |> should.equal(Ok(3))
  grid.get(g, #(1, 1)) |> should.equal(Ok(4))

  grid.get(g, #(5, 0)) |> should.equal(Error(Nil))

  dict.size(g.cells) |> should.equal(4)
}

pub fn grid_is_generic_test() {
  let g = grid.from_list([[True, False]])
  grid.get(g, #(0, 0))
  |> should.equal(Ok(True))
}

pub fn grid_lines_test() {
  let g = grid.from_list([[1, 2], [3, 4], [5, 6]])
  grid.lines(g)
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
