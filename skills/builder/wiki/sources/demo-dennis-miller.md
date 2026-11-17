---
title: dennis-miller demo
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/websites-demo/dennis-miller/", "raw/yootheme-pro-5.0.33/vendor/assets/uikit-themes/master-dennis-miller/"]
tags: [source, demo, portfolio, agency, overlay]
updated: 2026-07-29
---

# dennis-miller demo

A creative studio portfolio with per-person pages (`jacob-peterson`, `daniel-brighton`). 8 pages,
591 nodes, 24 element types. Part of [[sources/websites-demo]].

## Element mix

`column` 131 · `row` 79 · `list_item` 76 · `headline` 56 · `image` 45 · `section` 36 · `grid_item` 30 ·
`overlay` 24 · `social_item` 21 · `text` 18 · `panel` 17

`services.json` alone is 183 nodes — the largest single page in the corpus after `fc-greenfield/home`.

Two element choices stand out: **`overlay` 24** (the third-highest in the corpus) and **`list_item` 76**
with only 5 `list` containers — long lists, not many short ones.

## What it teaches

- **`width: expand` 30 times, more than `default` 6.** This is the full-bleed idiom: the section
  container is released and the row runs edge to edge. Contrast with `balou`, which never uses it
- **`style: secondary` on 8 sections** — the only demo besides `design-bites` to lean on the dark
  section style at volume, and it pairs with `@global-secondary-background: #1B1B1B`
- `panel_style: card-primary` on all 5 panels: red cards on white, matching `@global-primary-background: #F62423`
- `animation`: `parallax` 71, `fade` 9, `slide-top-small` 4 — parallax-dominant like most of the corpus
- `link_style` appears as **both** a string (`default` 45, `button` 7, `text` 3) and a boolean
  (`true` 12) — the boolean instances are all `headline`, see [[props/link]]
- `media_background: #fff` on 3 nodes — background media colour set as a flat value, see [[props/media]]

## `css` usage — 46 nodes, 7,8%

`image` 30 · `section` 6 · `panel` 5 · `row` 4 · `grid` 1.

The image idiom is unusually tight — `max-width: 10vw` appears 22 times, half of them paired with
`pointer-events: none` on the wrapper:

```css
.el-element { pointer-events: none; }
.el-image { max-width: 10vw; }
```

That pair is the signature of a **decorative image floated over content**: sized fluidly, and made
click-through so it does not steal the underlying link. There is no native prop for either half.

The `panel` rules build a circular badge that the builder cannot express:

```css
.el-element { width: 200px; }
.el-element > * { display: flex !important; align-items: center; justify-content: center;
                  min-height: 200px; border-radius: 500px; }
```

One rule is a mobile repair rather than a design: `@media (max-width: 640px) { .el-element { position: relative!important; top: 0!important; } }` — undoing an absolutely positioned element below the breakpoint,
which [[props/position]] has no prop for.

## The theme — `master-dennis-miller`

560 lines.

| | |
|---|---|
| fonts | Archivo 400-500 body / Sora 600-700 headings |
| `@global-font-size` | `16px`, `@global-2xlarge-font-size: 42px` |
| palette | pure `#000` text and emphasis on `#fff`, link and primary `#F62423` |
| `@global-secondary-background` | `#1B1B1B` |
| `@global-border-radius` | `2px` but `@button-border-radius: 500px` |
| `@base-h1-font-size` | `@global-xlarge-font-size` — h1 is deliberately *smaller* than the 2xlarge scale |

The pill button (`500px` radius) against a `2px` global radius is a theme-level decision that no layout
prop exposes: every `button` in all 8 pages inherits it. See [[concepts/customizer-less-map]].

5 style variants, and unusually two of them are dark: `black-green`, `black-red`, `colored-blue`,
`colored-yellow`, `white-green`.

## Caveats

7 of 8 exports are `5.0.32`; `home.json` is `5.0.0-beta.8`.
