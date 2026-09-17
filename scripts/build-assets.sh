#!/usr/bin/env bash
# Bitmaps the Keynote build needs. Keynote cannot place SVG, so the logo and the
# icon row are rendered to transparent PNGs, and the slide ground is a flat image
# because AppleScript cannot set a slide background colour.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/build/keyassets"
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
mkdir -p "$out"

ground="0xF4F0FF"
panel="0xE6DEFA"

ffmpeg -y -loglevel error -f lavfi -i "color=c=$ground:s=1920x1080" -frames:v 1 "$out/bg.png"
ffmpeg -y -loglevel error -f lavfi -i "color=c=$panel:s=795x120" -frames:v 1 "$out/panel-left.png"
ffmpeg -y -loglevel error -f lavfi -i "color=c=$panel:s=795x440" -frames:v 1 "$out/panel-right.png"

# Icon row, lifted straight out of index.html so the two never drift apart.
python3 - "$root" "$out" <<'PY'
import re, sys, pathlib
root, out = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
icons = re.search(r'<span class="social__icons">(.*?)</span>',
                  (root / "index.html").read_text(), re.S).group(1)
icons = icons.replace('width="32"', 'width="64"').replace('height="32"', 'height="64"')
icons = icons.replace('width="35"', 'width="70"')
(out / "icons.html").write_text(
    '<body style="margin:0"><div style="display:inline-flex;align-items:center;'
    'gap:42px;color:#4A3C4E">' + icons + '</div></body>')
(out / "logo.html").write_text(
    '<body style="margin:0"><img src="%s" width="720"></body>'
    % (root / "assets" / "mindtrek-logo.svg"))
PY

"$chrome" --headless --disable-gpu --default-background-color=00000000 \
  --screenshot="$out/icons-full.png" --window-size=760,80 "$out/icons.html" 2>/dev/null
"$chrome" --headless --disable-gpu --default-background-color=00000000 \
  --screenshot="$out/logo-full.png" --window-size=730,110 "$out/logo.html" 2>/dev/null

ffmpeg -y -loglevel error -i "$out/icons-full.png" -vf "crop=706:64:0:0,format=rgba" "$out/icons.png"
ffmpeg -y -loglevel error -i "$out/logo-full.png" -vf "crop=720:93:0:0,format=rgba" "$out/mindtrek.png"

rm -f "$out"/*-full.png "$out"/*.html
echo "assets built in $out"
