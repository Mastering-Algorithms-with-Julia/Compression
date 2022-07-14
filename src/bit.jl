function bitget(bits::Vector{UInt8}, pos::Int)
  mask = 0x80
  for _ = 1 : pos % 8 - 1
    mask = mask >> 1
  end

  return mask & bits[floor(Int, pos / 8) + 1] == mask ? 1 : 0
end

function bitset!(bits::AbstractArray{UInt8}, pos::Int, state::Int)
  mask = 0x80

  for _ = 1 : pos % 8 - 1
    mask = mask >> 1
  end

  if state == 1
    bits[floor(Int, pos / 8) + 1] = bits[floor(Int, pos / 8) + 1] | mask
  else
    bits[floor(Int, pos / 8) + 1] = bits[floor(Int, pos / 8) + 1] & (~mask)
  end
end


function bitxor(bits1::Vector{UInt8}, bits2::Vector{UInt8})
  size = length(bits1)
  bitsx = Vector{UInt8}(undef, size)

  for index = 1:size
    if bitget(bits1, index) != bitget(bits2, index)
      bitset!(bitsx, index, 1)
    else
      bitset!(bitsx, index, 0)
    end
  end

  return bitsx
end

function bitrotateleft!(bits::Vector{UInt8}, size::Int, count::Int)
  isempty(bits) && return

  fbit, lbit, i, j = 0, 0, 0, 0
  for j = 1:count
    for i in 1:floor(Int, size / 8)
      lbit = bitget(bits[i:end], 1)
      if i == 1
        fbit = lbit
      else
        bitset!(view(bits, (i - 1):length(bits)), 8, lbit)
      end
      
      bits[i] = bits[i] << 1
    end

    bitset!(bits, size, fbit)
  end
  
end
