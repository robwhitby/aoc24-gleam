import gleam/list

pub type Point {
  Point(x: Int, y: Int)
}

pub fn add(from: Point, step: Point) -> Point {
  Point(from.x + step.x, from.y + step.y)
}

pub fn subtract(from: Point, step: Point) -> Point {
  Point(from.x - step.x, from.y - step.y)
}

pub fn neighbours(from: Point, steps: List(Point)) -> List(Point) {
  steps |> list.map(add(from, _))
}

pub fn flip(point: Point) -> Point {
  Point(point.y, point.x)
}
