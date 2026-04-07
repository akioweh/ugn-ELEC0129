#let theme(body) = {
  // set text(
  //   font: "Latin Modern Roman 12",
  //   size: 11pt,
  // )

  // set page(fill: black)
  // set text(fill: rgb(234, 223, 200))
  // show link: set text(fill: rgb(150, 200, 237))

  set par(linebreaks: "optimized", justify: true)

  set heading(numbering: "1.1.1.1  ")

  show title: set align(center)
  show title: set block(below: auto, above: auto)
  show title: set text(weight: "light", size: 22pt)

  show heading: set block(below: 10pt, above: auto)
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 12pt)

  show raw: set text(
    font: "JetBrains Mono",
    weight: 200,
    size: 9.5pt,
  )

  show link: set text(fill: purple)

  body
}
