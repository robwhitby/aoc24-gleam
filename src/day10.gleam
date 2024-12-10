import dir
import gleam/list
import grid.{Stepper}
import input

fn parse(in: List(String)) {
  input.int_parser(in, "")
}

pub fn part1(in: List(String)) -> Int {
  let g = grid.from_list(parse(in))
  let stepper =
    Stepper(
      steps: dir.nesw,
      valid_step: fn(from, to) { to.value == from.value + 1 },
      stop: fn(cell) { cell.value == 9 },
    )

  grid.filter(g, fn(value) { value == 0 })
  |> list.map(grid.routes(g, _, stepper))
  |> list.flat_map(list.unique)
  |> list.length
}

pub fn part2(in: List(String)) -> Int {
  let g = grid.from_list(parse(in))
  let stepper =
    Stepper(
      steps: dir.nesw,
      valid_step: fn(from, to) { to.value == from.value + 1 },
      stop: fn(cell) { cell.value == 9 },
    )

  grid.filter(g, fn(value) { value == 0 })
  |> list.flat_map(grid.routes(g, _, stepper))
  |> list.length
}
