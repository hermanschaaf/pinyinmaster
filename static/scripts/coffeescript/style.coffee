style = (selector, prop) ->
  cache = style.cache = style.cache or {}
  cid = selector + ":" + prop
  return cache[cid]  if cache[cid]
  parts = selector.split(RegExp(" +"))
  len = parts.length
  parent = root = document.createElement("div")
  child = undefined
  part = undefined
  i = 0

  while i < len
    part = parts[i]
    child = document.createElement("div")
    parent.appendChild child
    parent = child
    if "#" is part[0]
      child.setAttribute "id", part.substr(1)
    else child.setAttribute "class", part.substr(1)  if "." is part[0]
    ++i
  document.body.appendChild root
  ret = getComputedStyle(child)[prop]
  document.body.removeChild root
  cache[cid] = ret