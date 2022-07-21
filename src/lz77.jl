struct LZ77
  windowsize::Int
  buffersize::Int
end

function longestmatch(lz77::LZ77, inputbuffer::Vector{UInt8}, cursor::Int)
  pos = 0
  len = 0
  c = '\0'
  # STUB
  endbuffer = min(cursor + lz77.buffersize, length(inputbuffer))
  # STUB
  startindex = max(1, cursor - lz77.windowsize)

  for i in range(endbuffer, cursor + 1, step = -1)
    substring = inputbuffer[cursor:i]

    j = startindex
    while j < cursor && (cursor - j) >= length(substring)
      candidate = inputbuffer[range(j, j + length(substring))]
      if candidate == substring
        pos = j + lz77.windowsize - cursor
        len = length(candidate)

        if i == endbuffer
          len -= 1
          i -= 1
        end

        c = inputbuffer[i]
        break
      end
      j += 1
    end

    if len != 0
      break
    end
  end

  if pos == 0 || len == 0
    return (0, 0, inputbuffer[cursor])
  else
    return (pos, len, c)
  end
end

function lz77compress(lz77::LZ77, input::AbstractString)
  inputbuffer = Vector{UInt8}(input)
  lendata = length(inputbuffer)
  cursor = 1
  compressdata = Tuple{Int, Int, Char}[]
  while cursor <= lendata
    ret = longestmatch(lz77, inputbuffer, cursor)
    cursor += ret[1] + 1
    push!(compressdata, ret)
  end

  return compressdata
end

function lz77uncompress(lz77::LZ77, compresseddata::Vector{Tuple{Int, Int, Char}})
  cursor = 1
  out = ""

  for unit in compresseddata
    (pos, len, c) = unit

    if len > 0
      start = cursor - lz77.windowsize + pos
      out *= String(out[range(start, start + len)])
    end

    out *= c
    cursor += len + 1
  end

  return out
end