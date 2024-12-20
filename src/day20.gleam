import dir
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import grid.{type Grid}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let g = input.string_parser(in, "") |> grid.from_list
  let min_saving = case g.width {
    15 -> 50
    _ -> 100
  }
  #(g, min_saving)
}

pub fn part1(in: List(String)) {
  let #(g, min_saving) = parse(in)

  get_track(g)
  |> shortcuts(2, min_saving)
}

pub fn part2(in: List(String)) {
  let #(g, min_saving) = parse(in)

  get_track(g)
  |> shortcuts(20, min_saving)
}

fn get_track(g: Grid(String)) {
  let assert Ok(start) = grid.find(g, fn(v) { v == "S" })
  let points =
    grid.filter(g, fn(v) { v == "." || v == "E" })
    |> list.map(fn(c) { c.point })
    |> set.from_list
  walk_track([start.point], points)
}

fn walk_track(track: List(Point), rem: Set(Point)) {
  let assert Ok(p) = list.first(track)
  let next =
    point.neighbours(p, dir.nesw)
    |> list.find(fn(n) { set.contains(rem, n) })
  case next {
    Ok(p) -> walk_track([p, ..track], set.delete(rem, p))
    _ -> list.reverse(track)
  }
}

fn shortcuts(track: List(Point), max_length: Int, min_saving: Int) {
  let index =
    track
    |> list.index_map(fn(p, i) { #(p, i) })
    |> dict.from_list
  let idx = fn(p) { result.unwrap(dict.get(index, p), 0) }

  list.map(track, fn(p) {
    let p_idx = idx(p)
    let #(_, after_p) = list.split(track, p_idx + 3)
    list.count(after_p, fn(q) {
      let d = point.distance(p, q)
      d <= max_length && idx(q) - p_idx - d >= min_saving
    })
  })
  |> int.sum
}
