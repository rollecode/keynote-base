# Keynote base

Rolle's personal speaker template for slides.

## Structure

| Path | What it is |
| -- | -- |
| `index.html` | The three reference slides at 1920 x 1080. The source of truth for the design |
| `base.css` | The whole design system: tokens, type scale, slide layouts |
| `assets/` | The graded portrait and the two conference logos |
| `scripts/build-assets.sh` | Renders the bitmaps Keynote needs |
| `scripts/build-key.applescript` | Builds the Keynote master |
| `build/keynote-base.pdf` | The HTML printed to PDF, three pages |
| `build/Rolle speaker base.key` | The Keynote master to actually present from |

## Building

```
./scripts/build-assets.sh
osascript scripts/build-key.applescript
```

The PDF comes from headless Chrome, which is also what embeds the fonts:

```
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless \
  --no-pdf-header-footer --print-to-pdf=build/keynote-base.pdf index.html
```

## Typefaces

Free, all of them, and all installed in `~/Library/Fonts`. Keynote will not render the master without them.

| Role | Face | Source |
| -- | -- | -- |
| Display noun | Unbounded ExtraBold | Google Fonts |
| Display counter-phrase | Instrument Serif Italic | Google Fonts |
| Body | Geist | Google Fonts |
| Code | Geist Mono | Google Fonts |

The headline move is one Unbounded phrase followed by one Instrument Serif italic phrase in violet. It carries two clauses and falls apart at three, so headings stay short.

## Colours

| Token | Hex | Contrast on the ground |
| -- | -- | -- |
| Ground | `#F4F0FF` | |
| Ink | `#190834` | 16.7:1 |
| Violet | `#4C1D95` | 9.8:1 |
| Subtitle | `#3A2240` | 12.7:1 |
| Secondary | `#4A3C4E` | 9.2:1 |
| Event, the logo and its line | `#534669` | 7.7:1 |
| Body | `#2E1B34` | 14.2:1 |
| Code panel | `#E6DEFA` | its ink `#2B1B33` at 12.4:1 |

Nothing on a slide is below 7.5:1. The 2023 deck failed in a bright auditorium because a dark ground plus gradient text loses its contrast the moment ambient light washes the projection. Hence: light ground, flat fills, no gradient text anywhere.

## Portrait

`assets/portrait.jpg` is graded to the palette, matte, with the blacks lifted so nothing in the frame is truly dark and the lit side of the face is the brightest thing on the slide. No overlay sits on top of it; the grade is in the file.

Regenerating it from a new photo:

```
ffmpeg -i in.jpg -vf "format=gray,\
curves=master='0/0.24 0.20/0.35 0.45/0.70 0.68/0.91 0.85/0.99 1/1',\
format=rgb24,lutrgb=r='25+217*val/255':g='8+227*val/255':b='52+203*val/255'" \
  -q:v 3 assets/portrait.jpg
```

## Rules

- No borders.
- No ALL CAPS, eyebrows and labels included.
- No rounded cards with tinted fills. Hierarchy is type size and space.
- Type runs large. The cover headline is 138 pt on a 1920 slide.
- Colour never carries meaning on its own.
- The contact line is the monochrome icon row, then `rolle.social`, in that order.
- The byline is always "Founder and CTO, Digitoimisto Dude Oy".

## Keynote notes

The AppleScript build works around three limits, so do not be surprised by them:

- A slide background colour cannot be set from AppleScript, so the ground is a full-bleed PNG.
- Keynote cannot place SVG, so the logo and the icon row are rendered to transparent PNGs from the same files the HTML uses.
- Keynote text boxes centre their content vertically and use much looser line spacing than the browser, so every text item is given an explicit height and the code panels are sized to what Keynote actually renders rather than to what the CSS does.

Positions are close to the HTML, not identical. Nudge them in Keynote; that is what the file is for.
