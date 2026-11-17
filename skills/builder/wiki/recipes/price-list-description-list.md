---
title: price list with description_list
type: recipe
status: verified
yootheme_version: "5.0.32"
sources: ["[[sources/demo-glowbar]]", "[[sources/demo-balou]]"]
tags: [recipe, description-list, price-list, menu, importable]
updated: 2026-07-29
---

# Price list with `description_list`

Service menus, price lists, restaurant menus, spec sheets: name left, dotted leader, price right —
`description_list` with `title_leader`. The workhorse of [[sources/demo-glowbar]] (37 lists, 131
items) with smaller confirmation in [[sources/demo-balou]] (opening hours, product specs).

The content model: `title` is the term, `meta` is the value (the price), `content` is an optional
description line. No grid, no table — the element does the leader line and the two-column split
natively.

## Importable JSON

Trimmed from `raw/websites-demo/glowbar/pricing.json`.

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
        "width": "large"
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
                    "content": "Manicure",
                    "title_element": "h2",
                    "title_style": "heading-large",
                    "margin_bottom": "large"
                  }
                },
                {
                  "type": "description_list",
                  "props": {
                    "layout": "grid-2-m",
                    "list_element": "ul",
                    "title_leader": true,
                    "title_colon": false,
                    "title_style": "text-large",
                    "title_color": "emphasis",
                    "title_element": "div",
                    "title_grid_width": "expand",
                    "meta_style": "text-large",
                    "meta_color": "emphasis",
                    "meta_align": "below-content",
                    "maxwidth": "xlarge",
                    "column_breakpoint": "m",
                    "show_title": true,
                    "show_meta": true,
                    "show_content": true,
                    "show_link": true
                  },
                  "children": [
                    {
                      "type": "description_list_item",
                      "props": {
                        "title": "Classic Manicure",
                        "meta": "39€"
                      }
                    },
                    {
                      "type": "description_list_item",
                      "props": {
                        "title": "Gel Manicure",
                        "meta": "49€"
                      }
                    },
                    {
                      "type": "description_list_item",
                      "props": {
                        "title": "French Manicure",
                        "meta": "45€"
                      }
                    },
                    {
                      "type": "description_list_item",
                      "props": {
                        "title": "Paraffin Manicure",
                        "meta": "59€"
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

## Why each non-obvious prop is there

| Prop | Reason |
|---|---|
| `layout: "grid-2-m"` | Two list columns from tablet-landscape up, one below. `description_list.layout` has its own vocabulary (`grid-2`, `grid-2-m`) — nothing to do with `row.layout` despite the shared name ([[sources/websites-demo]]) |
| `title_leader: true` | The dotted line between name and price — the prop that makes it a price list |
| `title_colon: false` | Leaders and colons are alternatives; glowbar always disables the colon |
| `title_grid_width: "expand"` | The term takes the free space, the leader fills it, the price hugs the right edge |
| `title_element: "div"` | List terms are not headings — the corpus-wide semantics/style split |
| `meta_align: "below-content"` | Keeps the price aligned with the term row even when a `content` description line is present |
| `column_breakpoint: "m"` | Stacks below tablet — `m` is the corpus's universal stacking point |

## Variants

- **Restaurant menu** — add `content` to each item for the dish description; balou's
  usage. Item `content` renders under the term, price stays on the leader line
- **Full-bleed dark price page** — glowbar wraps each list in a [[recipes/sticky-cover-sections]]
  panel (`text_color: "light"`, `media_overlay`), one service category per pinned section, with an
  anchor `nav` menu at the top
- **Accordion form** — glowbar's five service pages carry the same price content inside
  `accordion` items instead: collapsed by default, one idiom per page density. 90 `accordion_item`
  nodes make it the corpus's second price-list idiom

## Related

[[sources/demo-glowbar]] · [[sources/demo-balou]] · [[recipes/sticky-cover-sections]] ·
[[props/meta-family]] · [[props/title-family]]
