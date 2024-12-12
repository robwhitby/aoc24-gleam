import gleeunit/should
import listx

pub fn count_contiguous_test() {
  listx.count_contiguous([])
  |> should.equal(0)

  listx.count_contiguous([1])
  |> should.equal(1)

  listx.count_contiguous([1, 2, 3, 10, 11, 12, 14, 16])
  |> should.equal(4)
}
