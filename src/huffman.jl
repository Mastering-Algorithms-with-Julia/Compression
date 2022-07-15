abstract type HuffmanTree end

struct HuffmanLeaf <: HuffmanTree
  symbol::Char
  freq::Int
end

struct HuffmanNode <: HuffmanTree
  freq::Int
  left::HuffmanTree
  right::HuffmanTree
end

function tablerecurse!(leaf::HuffmanLeaf, code::String, dict::Dict{Char, String})
  dict[leaf.symbol] = code
end

function tablerecurse!(node::HuffmanNode, code::String, dict::Dict{Char, String})
  tablerecurse!(node.left, string(code, "1"), dict)
  tablerecurse!(node.right, string(code, "0"), dict)
end

function countmap(phrase::AbstractString)
  dict = Dict{Char, Int}()

  for ch in phrase
    if !haskey(dict, ch)
      dict[ch] = 1
    else
      dict[ch] += 1
    end
  end

  return dict
  
end

function buildtable(node::HuffmanTree)
  dict = Dict{Char, String}()

  if isa(node, HuffmanLeaf)
    dict[node.symbol] = "0"
  else
    tablerecurse!(node, "", dict)
  end

  return dict
end

function buildtree(ftable::Dict{Char, Int})
  trees::Vector{HuffmanTree} = map(pair -> HuffmanLeaf(pair[1], pair[2]), collect(ftable))
  while length(trees) > 1
    sort!(trees, lt = (x, y) -> x.freq < y.freq, rev = true)
    least = pop!(trees)
    nextleast = pop!(trees)
    push!(trees, HuffmanNode(least.freq + nextleast.freq, least, nextleast))
  end

  return first(trees)
end

function encode(phrase::AbstractString, table::Dict{Char, String})
  reduce(string, map(value -> table[value], collect(phrase)))
end

function decode(huffmantree::HuffmanTree, bitstring::AbstractString)
  current = huffmantree
  finalstring = ""

  for value in bitstring
    if isa(huffmantree, HuffmanNode)
      if value == '1'
        current = current.left
      else
        current = current.right
      end

      if !isa(current, HuffmanNode)
        finalstring *= string(current.symbol)
        current = huffmantree
      end
    else
      finalstring *= string(huffmantree.symbol)
    end
  end

  return finalstring
end

function huffmancompress(phrase::AbstractString, huffmantree::HuffmanTree)
  table = buildtable(huffmantree)
  bitstring = encode(phrase, table)
  return bitstring
end

function huffmanuncompress(compressed::AbstractString, huffmantree::HuffmanTree)
  finalstring = decode(huffmantree, compressed)
  return finalstring
end