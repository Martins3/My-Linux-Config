return {
-- The same equation snippet, using LuaSnip's fmt function.
-- The snippet is not shorter, but it is more *human-readable*.
s({trig="eq", dscr="A LaTeX equation environment"},
  fmt( -- The snippet code actually looks like the equation environment it produces.
    [[
      \begin{equation}
          <>
      \end{equation}
    ]],
    -- The insert node is placed in the <> angle brackets
    { i(1) },
    -- This is where I specify that angle brackets are used as node positions.
    { delimiters = "<>" }
  )
),
}
