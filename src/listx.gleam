import gleam/list
import parallel_map.{MatchSchedulersOnline}

pub fn filter_not(in l: List(a), discarding predicate: fn(a) -> Bool) -> List(a) {
  list.filter(l, fn(a) { !predicate(a) })
}

pub fn pmap(input: List(a), mapping_func: fn(a) -> b) -> List(Result(b, Nil)) {
  parallel_map.list_pmap(input, mapping_func, MatchSchedulersOnline, 5000)
}
