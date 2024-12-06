import gleam/list

pub fn filter_not(in l: List(a), discarding predicate: fn(a) -> Bool) -> List(a) {
  list.filter(l, fn(a) { !predicate(a) })
}
