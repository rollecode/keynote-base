<h1 align="center">🚀 Keynote base</h1>

<p align="center">
  <strong>Rolle's personal speaker template for slides.</strong>
</p>

<p align="center">
  <img style="height:28px;width:auto;" src="https://github.com/user-attachments/assets/86155721-5148-4ca1-b2f1-9731af65bf27" alt="Keynote" />
  <img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white" alt="HTML" />
  <img src="https://img.shields.io/badge/PDF-b21c20?style=for-the-badge&logo=html5&logoColor=white" alt="PDF" />
  <img src="https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&color=%23222222&logo=gnu-bash&logoColor=white" alt="Bash" />
  <img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS" />
</p>

---

<img width="1941" height="1090" alt="image" src="https://github.com/user-attachments/assets/20e6ed12-95e4-467e-9582-9de4fd8971f1" />

> [!IMPORTANT]  
> These slides are a work in progress and subject to change. I like to build in public.

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

```bash
./scripts/build-assets.sh
osascript scripts/build-key.applescript
```

The PDF comes from headless Chrome, which is also what embeds the fonts:

```bash
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

```bash
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
