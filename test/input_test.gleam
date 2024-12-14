import gleeunit/should
import input

pub fn int_parser_test() {
  input.int_parser(["1 2"], False) |> should.equal([[1, 2]])
  input.int_parser(["1 2:3"], False) |> should.equal([[1, 2, 3]])
  input.int_parser(["123"], True) |> should.equal([[1, 2, 3]])

  input.int_parser(["12:34"], True) |> should.equal([[1, 2, 3, 4]])
  input.int_parser(["12:34"], False) |> should.equal([[12, 34]])

  input.int_parser(["12:-34"], False) |> should.equal([[12, -34]])
}
