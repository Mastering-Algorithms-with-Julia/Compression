using Compression, Test

@testset "test encryption" begin
  @testset "test bitxor" begin
    bits = Vector{UInt8}("hello world")
    @show bitxor(bits, bits)
  end

  @testset "test bitrotateleft" begin
    bits = Vector{UInt8}("hello world")
    @show bits
    bitrotateleft!(bits, length(bits), 2)
    @show map(Int, bits)
  end

  @testset "test huffman" begin
    phrase = "hello world"
    freq = countmap(phrase)
    huffmantree = buildtree(freq)

    compressed = huffmancompress("hello world", huffmantree)
    @show compressed
    @show huffmanuncompress(compressed, huffmantree)
  end

  @testset "test lz77" begin
    compressor = LZ77(6, 4)

    origin = "hello world"
    pack = lz77compress(compressor, origin)
    unpack = lz77uncompress(compressor, pack)

    @test unpack == origin
  end
end