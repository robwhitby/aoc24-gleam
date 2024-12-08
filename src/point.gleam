pub type Point {
  Point(x: Int, y: Int)
}

pub fn add(from: Point, step: Point) {
  Point(from.x + step.x, from.y + step.y)
}

pub fn subtract(from: Point, step: Point) {
  Point(from.x - step.x, from.y - step.y)
}
