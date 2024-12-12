import gleam/dict
import gleam/set
import gleeunit/should
import grid.{type Cell, Cell}
import point.{Point}

pub fn grid_test() {
  let g = grid.from_list([[1, 2, 3], [4, 5, 6]])
  g.width |> should.equal(3)
  g.height |> should.equal(2)

  grid.cell_at(g, Point(0, 0)) |> should.equal(Ok(Cell(Point(0, 0), 1)))
  grid.cell_at(g, Point(1, 1)) |> should.equal(Ok(Cell(Point(1, 1), 5)))

  grid.cell_at(g, Point(5, 0)) |> should.equal(Error(Nil))

  dict.size(g.cells) |> should.equal(6)
}

pub fn find_test() {
  let g = grid.from_list([[1, 2], [3, 4], [5, 6]])
  grid.find(g, fn(i) { i == 3 })
  |> should.equal(Ok(Cell(Point(0, 1), 3)))
}

// 1
// 111
//  11
pub fn perimeter_and_sides_test() {
  let area =
    set.from_list([
      Cell(Point(0, 0), 1),
      Cell(Point(0, 1), 1),
      Cell(Point(1, 1), 1),
      Cell(Point(2, 1), 1),
      Cell(Point(1, 2), 1),
      Cell(Point(2, 2), 1),
    ])
  grid.perimeter(area) |> should.equal(12)
  grid.sides(area) |> should.equal(8)
}
