---
title: parallax image collage
type: recipe
status: verified
yootheme_version: "5.0.32"
sources: ["[[sources/demo-balou]]", "[[sources/demo-kojiiro]]", "[[sources/demo-fc-greenfield]]", "[[sources/websites-demo]]"]
tags: [recipe, image, parallax, position, collage, css, importable]
updated: 2026-07-29
---

# Parallax image collage

Decorative images scattered around in-flow content, each drifting at its own speed — the
illustration clusters of [[sources/demo-balou]], the photo stacks of [[sources/demo-kojiiro]] and
[[sources/demo-fc-greenfield]], the floating UI chips of [[sources/demo-devstack]]. Five demos,
one technique: an anchor element in normal flow, siblings with `position: "absolute"` +
`animation: "parallax"`, and fluid sizing via one line of scoped CSS.

## Importable JSON

Trimmed from `raw/websites-demo/balou/home.json` (the about teaser: photo plus two drifting SVGs).

```json
{
  "type": "layout",
  "version": "5.0.43",
  "props": [],
  "children": [
    {
      "type": "section",
      "props": {
        "style": "default",
        "width": "xlarge"
      },
      "children": [
        {
          "type": "row",
          "props": {
            "layout": "1-2,1-2",
            "column_gap": "large"
          },
          "children": [
            {
              "type": "column",
              "props": {
                "vertical_align": "middle",
                "width_medium": "1-2"
              },
              "children": [
                {
                  "type": "image",
                  "props": {
                    "image": "wp-content/uploads/photo.jpg",
                    "image_width": "780"
                  }
                },
                {
                  "type": "image",
                  "props": {
                    "image": "wp-content/uploads/illustration-rainbow.svg",
                    "position": "absolute",
                    "position_bottom": "5vh",
                    "position_left": "-8vw",
                    "animation": "parallax",
                    "parallax_y": "0,-20vh",
                    "parallax_target": "!.uk-section",
                    "parallax_easing": "1",
                    "css": ".el-image { min-width: 180px; max-width: 25vw; }"
                  }
                }
              ]
            },
            {
              "type": "column",
              "props": {
                "width_medium": "1-2"
              },
              "children": [
                {
                  "type": "image",
                  "props": {
                    "image": "wp-content/uploads/illustration-bird.svg",
                    "position": "absolute",
                    "position_top": "-4vh",
                    "position_right": "2vw",
                    "animation": "parallax",
                    "parallax_y": "0,-30vh",
                    "parallax_target": "!.uk-section",
                    "parallax_easing": "1",
                    "css": ".el-image { max-width: 12vw; }"
                  }
                },
                {
                  "type": "headline",
                  "props": {
                    "content": "Inspired by Our Children",
                    "title_element": "h2",
                    "title_style": "heading-large"
                  }
                },
                {
                  "type": "text",
                  "props": {
                    "content": "Body copy for the teaser."
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

## The three legs of the technique

**1. Positioning** — `position: "absolute"` with `position_top/bottom/left/right` in viewport
units (`5vh`, `-8vw` — negative values push outside the column). The column is the positioning
context; the in-flow photo gives it its size. See [[props/position]].

**2. Motion** — `animation: "parallax"` + `parallax_y` with a two-value range (`"0,-20vh"`).
`parallax_target: "!.uk-section"` ties progress to the whole section's scroll rather than the small
image's own visibility window — without it, an element near the viewport edge barely moves.
Different `parallax_y` ranges per image create the depth stagger. See [[props/animation]].

**3. Fluid size** — `.el-image { max-width: NNvw; }` (optionally floored by `min-width: NNNpx`) in
the scoped `css` prop. **This is the single most common custom-CSS idiom in the corpus** —
`image_width` takes only pixels, so viewport-relative art direction has no prop. 135 `image` nodes
across the demos carry it. See [[concepts/custom-css-boundary]].

## Gotchas from the demos

- **Click-through**: [[sources/demo-dennis-miller]] and [[sources/demo-fc-greenfield]] add
  `.el-element { pointer-events: none; }` to decorative overlays so they do not steal clicks from
  links underneath — no prop exists for it
- **Mobile repair**: absolutely positioned collages often break on phones. dennis-miller undoes one
  with `@media (max-width: 640px) { .el-element { position: relative !important; top: 0 !important; } }`;
  the cleaner corpus idiom is `visibility: "s"` on the decoration (fc-greenfield: 17 nodes) —
  drop the ornament below phone-landscape instead of repositioning it
- **Anchoring higher**: [[sources/demo-line-gallery]] neutralises the column's positioning context
  with `.el-column > * { position: static; }` (×12) when a decoration must anchor to the row or
  section instead — position-context surgery, use sparingly
- The devstack variant swaps SVG ornaments for fixed-width shadowed UI chips
  (`width: 195px; box-shadow: …; border-radius`) over product screenshots — same skeleton, product
  marketing skin

## Related

[[props/position]] · [[props/animation]] · [[sources/demo-balou]] · [[sources/demo-kojiiro]] ·
[[sources/demo-devstack]] · [[sources/demo-line-gallery]] · [[recipes/fullscreen-hero-slideshow]]
