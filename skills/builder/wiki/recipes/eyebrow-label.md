---
title: eyebrow label
type: recipe
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/yootheme-pro-5.0.33-source]]", "[[sources/observation-eyebrow-custom-css]]"]
tags: [recipe, eyebrow, headline, meta, css, importable]
updated: 2026-07-29
---

# Eyebrow label

The short uppercase label above a heading. Three ways to build it, in order of preference. The
structural rule is unchanged in all three: a standalone eyebrow is a **separate `headline`
element** — never a `text` element, never an inline span inside another headline's `content`.

## 1. Standalone: `headline` + `css` prop (self-sufficient)

Style the eyebrow with the element's own `css` field (advanced group) instead of a theme class. The
JSON then imports with its styling attached — no companion LESS needed. Per
[[props/advanced-group]], `.el-element` is substituted with the element's generated HTML id;
`headline` offers **only** `.el-element` and `.el-link` (`headline/element.php:303`) — there is no
`.el-title` inside a headline, the heading tag *is* the element.

What props can do stays in props (`title_style`, `title_color`, `title_element`); the `css` field
carries only what no prop expresses — the uppercase and tracking.

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
        "width": "default"
      },
      "children": [
        {
          "type": "row",
          "props": {
            "layout": ""
          },
          "children": [
            {
              "type": "column",
              "props": {},
              "children": [
                {
                  "type": "headline",
                  "props": {
                    "content": "Ready to take the next step?",
                    "title_element": "div",
                    "title_style": "text-meta",
                    "title_color": "primary",
                    "css": ".el-element { text-transform: uppercase; letter-spacing: 0.1em; font-weight: 600; }"
                  }
                },
                {
                  "type": "headline",
                  "props": {
                    "content": "Start for free today",
                    "title_element": "h2",
                    "title_style": "h2",
                    "margin_top": "small"
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

Side effects to know, both from [[props/advanced-group]]: filling `css` gives the element a
**generated HTML `id`** if it has none, and the compiled CSS is **hoisted onto the layout's root
node**, not emitted in place. Neither is harmful; both surprise in an export diff.

## 2. Inside a card: the built-in `meta` slot

`panel`, `grid` and the other card elements already have an eyebrow slot:
`meta_align: "above-title"` — see [[props/meta-family]]. Prefer it to a nested headline: it keeps
the label inside the card's own flex flow. If the default `text-meta` look is not enough, the
element's `css` prop reaches the emitted class with `.el-meta` (a **real** class on the sub-part,
scoped as a descendant — not a placeholder):

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
        "width": "default"
      },
      "children": [
        {
          "type": "row",
          "props": {
            "layout": ""
          },
          "children": [
            {
              "type": "column",
              "props": {},
              "children": [
                {
                  "type": "grid",
                  "props": {
                    "grid_default": "1",
                    "grid_small": "2",
                    "grid_medium": "3",
                    "grid_column_gap": "medium",
                    "grid_row_gap": "medium",
                    "panel_style": "card-default",
                    "show_title": true,
                    "show_meta": true,
                    "show_content": true,
                    "title_element": "h3",
                    "meta_style": "text-meta",
                    "meta_align": "above-title",
                    "meta_element": "div",
                    "css": ".el-meta { text-transform: uppercase; letter-spacing: 0.08em; }"
                  },
                  "children": [
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Feature",
                        "title": "Organise",
                        "content": "<p>Put your ideas in order and set priorities.</p>"
                      }
                    },
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Feature",
                        "title": "Collaborate",
                        "content": "<p>Work with your team in one shared space.</p>"
                      }
                    },
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Feature",
                        "title": "Grow",
                        "content": "<p>Track progress and keep improving.</p>"
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
  ]
}
```

On `grid` the `css` is set once on the grid, not per item — the descendant scoping styles every
card's `.el-meta`. `.el-item` exists too (grid only) for per-card targeting.

## 3. Theme class: `class: "tm-eyebrow"`

The pre-v2.2.0 canonical form: the eyebrow `headline` carries `class: "tm-eyebrow"` and the theme's
LESS defines the style once. Still the right call when a project **already ships** that class —
one definition, reused everywhere, restyled in one place. The trade-off is the inverse of way 1:
centralised reuse versus a JSON that silently renders unstyled on themes without the class. Way 1
repeats a one-line `css` block per instance but never depends on the theme.

## Related

[[props/advanced-group]] · [[props/meta-family]] · [[elements/grid]] · [[elements/panel]] ·
[[sources/observation-eyebrow-custom-css]] · [[issues/eyebrow-styling-approach]]
