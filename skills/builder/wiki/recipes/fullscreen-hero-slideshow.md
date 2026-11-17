---
title: fullscreen hero slideshow
type: recipe
status: verified
yootheme_version: "5.0.32"
sources: ["[[sources/demo-balou]]", "[[sources/websites-demo]]"]
tags: [recipe, slideshow, hero, header-transparent, viewport, importable]
updated: 2026-07-29
---

# Fullscreen hero slideshow

A full-viewport slideshow behind a transparent header — the opening move of
[[sources/demo-balou]] (`home.json`), also used dynamically by [[sources/demo-framerate]].
The section supplies the transparent-header contract, the slideshow supplies the viewport height:
the two halves live on different nodes and both are required.

## Importable JSON

Full `layout` object, importable as-is (the root format confirmed by every real export — see [[issues/root-format-object-not-array]]). Trimmed from the balou export
(`raw/websites-demo/balou/home.json`); serialisation noise removed, every kept prop verified
against `slideshow/element.php` in `raw/yootheme-pro-5.0.33/`.

```json
{
  "type": "layout",
  "version": "5.0.43",
  "props": [],
  "children": [
    {
      "type": "section",
      "props": {
        "style": "primary",
        "padding_top": "none",
        "padding_bottom": "none",
        "header_transparent": true,
        "header_transparent_noplaceholder": true,
        "header_transparent_text_color": "dark"
      },
      "children": [
        {
          "type": "row",
          "props": {},
          "children": [
            {
              "type": "column",
              "props": {
                "text_color": "light"
              },
              "children": [
                {
                  "type": "slideshow",
                  "props": {
                    "height_viewport": "viewport",
                    "height_viewport_offset": true,
                    "slideshow_animation": "fade",
                    "slideshow_autoplay": true,
                    "slideshow_autoplay_interval": "5",
                    "slideshow_autoplay_pause": true,
                    "slideshow_min_height": "600",
                    "animation": "parallax",
                    "image_width": "1840",
                    "text_align": "center",
                    "text_color": "light",
                    "title_element": "h2",
                    "title_style": "heading-2xlarge",
                    "meta_style": "h4",
                    "meta_align": "below-title",
                    "show_title": true,
                    "show_meta": true,
                    "show_content": true,
                    "show_link": true,
                    "margin_top": "remove",
                    "margin_bottom": "remove",
                    "nav_position": "bottom-center",
                    "nav_align": "center",
                    "slidenav_breakpoint": "s",
                    "slidenav_outside_breakpoint": "xl"
                  },
                  "children": [
                    {
                      "type": "slideshow_item",
                      "props": {
                        "title": "Knit & More",
                        "meta": "Inspired by Our Children",
                        "image": "wp-content/uploads/slide-01.jpg"
                      }
                    },
                    {
                      "type": "slideshow_item",
                      "props": {
                        "title": "Second Slide",
                        "meta": "Another line",
                        "image": "wp-content/uploads/slide-02.jpg"
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
| section `padding_top`/`padding_bottom: "none"` | The slideshow must own the full viewport; default section padding would add a frame. `"none"` is a real value, not an unset — see [[elements/section]] |
| `header_transparent` + `_noplaceholder` | Header overlays the slideshow, and the section is pulled up behind it. The transform writes global config, and **only the first such section on the page wins** ([[elements/section]]) |
| `header_transparent_text_color: "dark"` | The header's own contrast over the imagery — independent of the slideshow's `text_color` |
| `height_viewport: "viewport"` + `height_viewport_offset` | Full viewport minus the header height. Without the offset the slideshow overflows by the header's height when the header is *not* transparent |
| `slideshow_min_height: "600"` | Short-viewport floor — landscape phones get 600px, not 350 |
| `animation: "parallax"` | The slideshow's Ken-Burns-style content parallax within each slide — balou's only animation value, see [[props/animation]] |
| `column.text_color: "light"` | Contrast for the slide text over imagery; the balou export sets it on the column so nav arrows inherit too |
| `margin_top`/`margin_bottom: "remove"` | Kill the element margins inside the zero-padding section |
| `image_width: "1840"` | Caps the generated srcset — hero images need width, not the 3200px original |

## Gotchas from the demo

- balou pairs this with scoped CSS `.el-item { --uk-inverse: dark !important; }` to force the
  inverse colour mode per slide, and hides `.el-meta` under 640px — both beyond props, kept out of
  the snippet. See [[concepts/custom-css-boundary]]
- The demo places CTA buttons as separate `button` elements with `position: "absolute"` +
  `position_bottom: "5vh"` over the slideshow — duplicated per breakpoint with mirrored
  `visibility` (`m` / `hidden-m`) because the two variants differ in `fullwidth`, a prop
  `visibility` cannot switch. See [[sources/websites-demo]], "Recurring techniques"
- Dynamic variant: [[sources/demo-framerate]] binds `slideshow_item` nodes to a custom source via
  the node-level `source` key — the hero *is* the post loop. See [[concepts/dynamic-content]]

## Related

[[elements/section]] · [[props/slider-nav]] · [[props/animation]] · [[props/media]] ·
[[sources/demo-balou]] · [[sources/demo-framerate]]
