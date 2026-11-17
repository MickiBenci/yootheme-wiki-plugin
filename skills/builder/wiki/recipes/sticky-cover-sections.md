---
title: sticky cover sections
type: recipe
status: verified
yootheme_version: "5.0.32"
sources: ["[[sources/demo-glowbar]]", "[[sources/demo-fc-greenfield]]", "[[sources/websites-demo]]"]
tags: [recipe, section, sticky, cover, parallax, importable]
updated: 2026-07-29
---

# Sticky cover sections

Each full-height section pins in place while the next one slides over it — the signature scroll of
[[sources/demo-glowbar]]'s `pricing.json` (11 of the corpus's 12 uses). Built entirely from section
props: `sticky: "cover"` plus a parallax `target` trick that makes the pinned section's content
move while it is being covered.

`section.sticky` takes `''` / `'cover'` / `'reveal'` (`section/element.php:212`): *"Sticky section
will be covered by the following section while scrolling. Reveal section by previous section."*

## Importable JSON

Two cover sections and a normal closing section. Trimmed from
`raw/websites-demo/glowbar/pricing.json`.

```json
{
  "type": "layout",
  "version": "5.0.43",
  "props": [],
  "children": [
    {
      "type": "section",
      "props": {
        "sticky": "cover",
        "style": "primary",
        "width": "xlarge",
        "height": "viewport",
        "vertical_align": "middle",
        "text_color": "light",
        "id": "first",
        "image": "wp-content/uploads/bg-01.jpg",
        "image_size": "cover",
        "image_width": "2560",
        "image_effect": "parallax",
        "image_parallax_bgy": "-30vh",
        "image_parallax_start": "-100vh",
        "image_parallax_end": "100%",
        "image_parallax_target": "![class*='uk-section-'] ~ [class*='uk-section-']",
        "media_overlay": "rgba(0, 0, 0, 0.75)"
      },
      "children": [
        {
          "type": "row",
          "props": {},
          "children": [
            {
              "type": "column",
              "props": {},
              "children": [
                {
                  "type": "headline",
                  "props": {
                    "content": "First Panel",
                    "title_element": "h2",
                    "title_style": "heading-large",
                    "animation": "parallax",
                    "parallax_y": "15vh,-15vh",
                    "parallax_start": "-100vh",
                    "parallax_end": "100%+10vh",
                    "parallax_target": "![class*='uk-section-'] ~ [class*='uk-section-']"
                  }
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "type": "section",
      "props": {
        "sticky": "cover",
        "style": "primary",
        "width": "xlarge",
        "height": "viewport",
        "vertical_align": "middle",
        "text_color": "light",
        "id": "second",
        "image": "wp-content/uploads/bg-02.jpg",
        "image_size": "cover",
        "image_width": "2560",
        "image_effect": "parallax",
        "image_parallax_bgy": "-30vh",
        "image_parallax_start": "-100vh",
        "image_parallax_end": "100%",
        "image_parallax_target": "![class*='uk-section-'] ~ [class*='uk-section-']",
        "media_overlay": "rgba(0, 0, 0, 0.75)"
      },
      "children": [
        {
          "type": "row",
          "props": {},
          "children": [
            {
              "type": "column",
              "props": {},
              "children": [
                {
                  "type": "headline",
                  "props": {
                    "content": "Second Panel",
                    "title_element": "h2",
                    "title_style": "heading-large"
                  }
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "type": "section",
      "props": {
        "style": "default"
      },
      "children": [
        {
          "type": "row",
          "props": {},
          "children": [
            {
              "type": "column",
              "props": {},
              "children": [
                {
                  "type": "headline",
                  "props": {
                    "content": "Normal flow resumes"
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

## How the target trick works

A pinned section does not scroll, so parallax driven by its own position would freeze the moment it
sticks. Every parallax in the pattern therefore sets

```
parallax_target: ![class*='uk-section-'] ~ [class*='uk-section-']
```

UIkit target syntax: `!` climbs to the closest ancestor matching `[class*='uk-section-']` (the
section wrapper), `~` selects its **following sibling section** — so the animation progresses with
the *covering* section's travel. `parallax_start: "-100vh"` / `parallax_end: "100%"` widen the
active window to the full cover distance. The same selector drives the background
(`image_parallax_*`) and the children (`parallax_y: "15vh,-15vh"` — content drifts up as it is
covered).

## Why each non-obvious prop is there

| Prop | Reason |
|---|---|
| `sticky: "cover"` on every section **except the last** | The final section must scroll normally to release the stack |
| `height: "viewport"` + `vertical_align: "middle"` | Each panel owns a screen; alignment only works when a height is set ([[elements/section]]) |
| `media_overlay: "rgba(0, 0, 0, 0.75)"` | Legibility over photography — glowbar uses 0.75 on all 23 backgrounds |
| `id` on each section | glowbar pairs the stack with a `nav` of `#anchor` links for in-page wayfinding; the `id` prop is the anchor ([[props/advanced-group]]) |
| `image_parallax_bgy: "-30vh"` | The background creeps upward while pinned — depth against the sliding cover |

## Variants

- **`sticky: "reveal"`** — the mirror image: the section hides *under* the previous one and is
  revealed as it scrolls away. Unused in the corpus
- **Manual cover** — [[sources/demo-kojiiro]] and [[sources/demo-quantum-flares]] build the same
  visual with scoped CSS (`.el-row { margin-top: -100vh; }` + `z-index`) instead of the prop —
  the pre-prop idiom, more fragile, kept for reference in [[concepts/custom-css-boundary]]
- [[sources/demo-fc-greenfield]] uses a single `cover` on `the-club.json` as a one-off hero
  transition rather than a stack

## Related

[[elements/section]] · [[props/animation]] · [[props/media]] · [[sources/demo-glowbar]] ·
[[recipes/price-list-description-list]]
