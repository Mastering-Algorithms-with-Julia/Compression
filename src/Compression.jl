module Compression

include("bit.jl")
include("huffman.jl")

export bitxor, bitrotateleft!
export huffmancompress, huffmanuncompress, countmap, buildtree
end # module
