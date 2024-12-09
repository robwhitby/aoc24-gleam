import gleam/int
import gleam/list
import gleam/result

pub fn part1(in: List(Int)) -> Int {
  parse(in)
  |> defrag([])
  |> checksum
}

pub fn part2(in: List(Int)) -> Int {
  parse(in)
  |> defrag_files([])
  |> checksum
}

type Disk =
  List(Entry)

pub type Entry {
  File(id: Int, length: Int)
  Space(length: Int)
}

fn parse(in: List(Int)) -> Disk {
  list.index_map(in, fn(len, idx) {
    case int.is_even(idx) {
      True -> Ok(File(idx / 2, len))
      False -> Ok(Space(len))
    }
  })
  |> result.values
}

fn checksum(disk: Disk) -> Int {
  list.flat_map(disk, fn(e) {
    case e {
      File(idx, len) -> list.repeat([idx], len)
      Space(len) -> list.repeat([0], len)
    }
  })
  |> list.flatten
  |> list.index_map(fn(a, idx) { a * idx })
  |> int.sum
}

fn defrag(disk: Disk, out: Disk) -> Disk {
  
  let is_space = fn(e: Entry) {
    case e {
      Space(_) -> True
      _ -> False
    }
  }
  
  case disk {
    [] -> list.reverse(out)
    [File(_, _) as f, ..tail] -> defrag(tail, [f, ..out])
    [Space(0), ..tail] -> defrag(tail, out)
    [Space(gap), ..tail] -> {
      case list.reverse(tail) |> list.drop_while(is_space) {
        [File(_, len) as f, ..tailr] if len == gap ->
          defrag(list.reverse(tailr), [f, ..out])
        [File(_, len) as f, ..tailr] if len < gap -> {
          defrag([Space(gap - len), ..list.reverse(tailr)], [f, ..out])
        }
        [File(id, len), ..tailr] if len > gap -> {
          defrag(list.reverse([File(id, len - gap), ..tailr]), [
            File(id, gap),
            ..out
          ])
        }
        _ -> defrag([], out)
      }
    }
  }
}

fn defrag_files(disk: Disk, done: Disk) -> Disk {
  case list.reverse(disk) {
    [] -> list.flatten([disk, done])
    [e] -> [e, ..done]
    [File(_, _) as f, ..tail] -> {
      let #(d, e) = replace_space(list.reverse(tail), f)
      defrag_files(d, [e, ..done])
    }
    [s, ..tail] -> defrag_files(list.reverse(tail), [s, ..done])
  }
}

fn replace_space(disk: Disk, file: Entry) -> #(Disk, Entry) {
  let assert File(_, len) = file
  let #(left, right) =
    list.split_while(disk, fn(e) {
      case e {
        Space(n) -> n < len
        File(_, _) -> True
      }
    })

  case right {
    [Space(n) as s, ..rest] if n == len -> #(
      list.flatten([left, [file], rest]),
      s,
    )
    [Space(n), ..rest] if n > len -> #(
      list.flatten([left, [file, Space(n - len)], rest]),
      Space(len),
    )
    _ -> #(disk, file)
  }
}

