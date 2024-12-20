import dir
import gleam/dict
import gleam/int
import gleam/list
import gleam/set.{type Set}
import grid.{type Grid}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let g = input.string_parser(in, "") |> grid.from_list
  let min_saving = case g.width {
    15 -> 8
    _ -> 100
  }
  #(g, min_saving)
}

pub fn part1(in: List(String)) {
  let #(g, min_saving) = parse(in)

  get_track(g)
  |> shortcuts(min_saving)
}

pub fn part2(_in: List(String)) {
  0
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

fn shortcuts(track: List(Point), min_saving: Int) {
  let idx =
    track
    |> list.index_map(fn(p, i) { #(p, i) })
    |> dict.from_list

  track
  |> list.map(fn(p) {
    let assert Ok(p_idx) = dict.get(idx, p)
    [
      point.add(p, Point(0, -2)),
      point.add(p, Point(2, 0)),
      point.add(p, Point(0, 2)),
      point.add(p, Point(-2, 0)),
      point.add(p, Point(1, 1)),
      point.add(p, Point(-1, -1)),
      point.add(p, Point(1, -1)),
      point.add(p, Point(-1, 1)),
    ]
    |> list.map(dict.get(idx, _))
    |> list.count(fn(j) {
      case j {
        Ok(j) -> j - p_idx >= min_saving + 2
        _ -> False
      }
    })
  })
  |> int.sum
}
