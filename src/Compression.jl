module Compression

include("bit.jl")
include("huffman.jl")
include("lz77.jl")

export bitxor, bitrotateleft!
export huffmancompress, huffmanuncompress, countmap, buildtree
export lz77compress, lz77uncompress, LZ77
end # module
