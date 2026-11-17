---
title: service card grid
type: recipe
status: verified
yootheme_version: "5.0.33"
sources: ["[[sources/production-layout-sample]]", "[[sources/yootheme-pro-5.0.33-source]]"]
tags: [recipe, grid, card, services, importable]
updated: 2026-07-29
---

# Service card grid

The most common section on a service or product site: a heading, then a responsive row of clickable
cards with image, category label, title, description and a link. Derived from the third grid of
[[sources/production-layout-sample]], a production layout, with the prop set tightened against
the source definitions.

Responsive behaviour: 1 column on phone portrait, 2 from phone landscape, 3 from tablet landscape.

## Importable JSON

Full `layout` object, importable as-is through the builder Library (see [[issues/root-format-object-not-array]]). Every prop is
verified against `element.php` in `raw/yootheme-pro-5.0.33/`; no node `id`, no `null`, `props`
objects and `children` arrays throughout.

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
        "width": "default",
        "padding_top": "large",
        "padding_bottom": "large",
        "vertical_align": "middle"
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
                    "content": "Our classes",
                    "title_element": "h2",
                    "title_style": "h2",
                    "text_align": "center",
                    "margin_bottom": "medium"
                  }
                },
                {
                  "type": "grid",
                  "props": {
                    "grid_default": "1",
                    "grid_small": "2",
                    "grid_medium": "3",
                    "grid_column_gap": "medium",
                    "grid_row_gap": "medium",
                    "panel_style": "card-default",
                    "panel_padding": "default",
                    "panel_link": true,
                    "panel_link_hover": true,
                    "panel_image_no_padding": true,
                    "show_title": true,
                    "show_meta": true,
                    "show_content": true,
                    "show_image": true,
                    "show_link": true,
                    "title_element": "h3",
                    "title_hover_style": "reset",
                    "meta_style": "text-meta",
                    "meta_align": "above-title",
                    "meta_element": "div",
                    "content_margin_auto": true,
                    "image_align": "top",
                    "image_width": 600,
                    "image_height": 400,
                    "link_style": "text",
                    "link_text": "Scopri",
                    "text_align": "left",
                    "margin_top": "default",
                    "margin_bottom": "default"
                  },
                  "children": [
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Functional",
                        "title": "Functional Training",
                        "content": "<p>Mobility, functional strength and hybrid training sessions.</p>",
                        "image": "wp-content/uploads/class-functional.jpg",
                        "image_alt": "Atleta durante una sessione di allenamento funzionale",
                        "link": "functional-training/"
                      }
                    },
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Combat",
                        "title": "Kickboxing",
                        "content": "<p>Programmes for kids, juniors and adults, with dedicated conditioning.</p>",
                        "image": "wp-content/uploads/class-kickboxing.jpg",
                        "image_alt": "Allenamento di kickboxing al sacco",
                        "link": "kickboxing/"
                      }
                    },
                    {
                      "type": "grid_item",
                      "props": {
                        "meta": "Martial arts",
                        "title": "Ju Jitsu and self-defence",
                        "content": "<p>Technique, control and distance management, for every level.</p>",
                        "image": "wp-content/uploads/class-jujitsu.jpg",
                        "image_alt": "Dimostrazione di una tecnica di ju jitsu",
                        "link": "ju-jitsu-self-defence/"
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
| `row.layout: ""` | A single full-width column. `'1-1'` is the same thing — `row/updates.php:85-86` unsets it — but `''` is the canonical stored form |
| `column.props: {}` | Nothing to configure. **Do not put `text_align` here**: `column` does not declare it in 5.0.33 — see the gotcha below |
| `grid.text_align: "left"` | Card text reads left-aligned while the heading is centred. Text alignment is a `grid` prop, applied to every card |
| `panel_link` + `panel_link_hover` | Whole card clickable, with the `uk-card-hover` background shift. `panel_link_hover` only works on `card-default\|primary\|secondary\|overlay` and `tile-*` — see [[uikit/uk-card]] |
| `panel_image_no_padding` | The image bleeds to the card edge via `uk-card-media-top` instead of sitting inside the padded body |
| `content_margin_auto` | **The prop that makes the row look professional.** It sets the internal `content_expand` flag, so the description absorbs the slack and every card's link lands on the same baseline regardless of text length. See [[elements/panel]] |
| `image_width` / `image_height` | 600×400 forces a consistent 3:2 crop. Without them, mixed source ratios make the cards ragged |
| `meta_align: "above-title"` | Category label above the title — the eyebrow position |
| `title_hover_style: "reset"` | Default. Without it a linked title picks up link colouring, which fights the card |
| `link_style: "text"` | `uk-button-text` — an understated inline link rather than a filled button inside every card |
| `grid_column_gap` / `grid_row_gap` both `"medium"` | Equal values emit a single `uk-grid-medium`; different values emit the split `uk-grid-column-*` + `uk-grid-row-*` pair. See [[uikit/uk-grid]] |

## Gotcha: `panel_link` strips HTML from the content

`panel/templates/template-link.php:15-27` runs `title`, `meta` and `content` through `striptags()`
when `panel_link` is on **and** the item has a link — nested anchors inside a card-wide anchor would
be invalid markup. An item with no `link` value keeps its markup, so the behaviour can vary from
card to card within the same grid.

**Every item in the snippet above has a link, so their `<p>` tags are stripped at render.** They are kept
because they are correct authoring and survive if you later turn `panel_link` off. If a card needs
bold text or an inline link inside its content, drop `panel_link` and use `title_link` +
`image_link` instead. See [[props/link]].

## Gotcha: inert props survive an export

Checking the production layout in [[sources/production-layout-sample]] prop by prop against
`element.php` turns up three props the builder does not define in 5.0.33:

| Prop | Occurrences | Verdict |
|---|---|---|
| `column.text_align` | 5 | Not declared. Column text alignment must be set on the elements inside it |
| `column.width_medium` | 4 | ~~Pre-5.0 leftover — column widths now live in the parent row's `layout` string~~ **Corrected 2026-07-29: this claim was wrong.** `width_*` are live per-breakpoint props, edited via the row's *Column Layout* panel (`child-prop` fields) and rendered directly by `column/templates/template.php:45-51`. See [[issues/column-width-props]] |
| `gallery.panel_image_no_padding` | 1 | Declared on `panel` and `grid`, not on `gallery` |

The builder does not reject unknown props: `NormalizeTransform` fills in every *declared* field that
is missing, and simply carries anything else through untouched. **An undeclared prop is silently
inert** — no error, no warning, and it survives the next export. When a prop "does nothing", check
it exists on that element type before looking anywhere else.

## Variants

- **Statistics strip** — `show_image: false`, `show_content: false`, `show_link: false`,
  `grid_divider: true`, `title_style: "heading-2xlarge"`, `title_element: "div"`. Grid 1 of the same
  production layout. `title_element: "div"` matters: a big number is not a section heading
- **Team cards** — `panel_style: ""`, `image_border: "rounded"`, `show_content: false`. Grid 2
- **Filterable portfolio** — add `filter: true` and a `tags` prop on each item. See
  [[elements/grid]]
- **Lightbox gallery** — `lightbox: true`, with `image` on each item pointing at the full-size file

## Related

[[elements/grid]] · [[elements/grid_item]] · [[elements/panel]] · [[elements/section]] ·
[[uikit/uk-grid]] · [[uikit/uk-card]] · [[props/link]] · [[props/margin]] ·
[[issues/element-types-skill-vs-source]]
