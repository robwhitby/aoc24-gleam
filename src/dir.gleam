pub type Dir =
  #(Int, Int)

pub const n = #(0, -1)

pub const e = #(1, 0)

pub const s = #(0, 1)

pub const w = #(-1, 0)

pub const ne = #(1, -1)

pub const nw = #(-1, -1)

pub const se = #(1, 1)

pub const sw = #(-1, 1)

pub const all = [n, e, s, w, ne, nw, se, sw]

pub const nesw = [n, e, s, w]

pub const diag = [ne, nw, se, sw]
