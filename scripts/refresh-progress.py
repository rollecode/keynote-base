"""Recompute a handed-over talk's timing bars from the live Keynote document.

    python3 scripts/refresh-progress.py talks/<name> [--until N]

--until N times only slides 1..N, the part actually presented. Slides after it
(parked drafts, a review block) get a full bar.

After handover the .key is the source of truth, so slide order and count can
only be read from Keynote itself. Each slide's weight is inferred from what is
on it, the weights are scaled to SLOT_MIN - QA_MIN, and every footer bar is
re-rendered and swapped in place. Text is never touched.
"""

import pathlib
import runpy
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))
import deck  # noqa: E402

DUMP = """
tell application "Keynote"
  set d to document "%s"
  set out to ""
  repeat with n from 1 to (count of slides of d)
    set s to slide n of d
    set imgs to ""
    repeat with im in (images of s)
      set imgs to imgs & (file name of im) & ","
    end repeat
    set big to 0
    set firstText to ""
    repeat with t in (text items of s)
      set tx to object text of t as text
      if tx is not "" then
        if firstText is "" then set firstText to tx
        set sz to size of object text of t
        if sz > big then set big to sz
      end if
    end repeat
    set out to out & n & "|" & imgs & "|" & (big as integer) & "|" & (count of text items of s) & "|" & firstText & linefeed
  end repeat
  return out
end tell
"""


def weight(imgs, big, count, first):
    """Minutes-weight of one slide, from what is on it."""
    if "portrait" in imgs:
        return 0.4                          # cover
    if "A quick poll" in first:
        return 0.4                          # one click of a reveal
    if "code-" in imgs:
        return 1.8
    if "timeline" in imgs:
        return 1.6
    if "rolle-90s" in imgs or "dudella" in imgs:
        return 1.5                          # about
    if count > 30:
        return 1.6                          # dense list
    if 90 <= big <= 130:
        return 0.5                          # statement
    return 1.0


def osa(script):
    return subprocess.run(["osascript", "-e", script], check=True,
                          capture_output=True, text=True).stdout


def main():
    talk = (ROOT / sys.argv[1]).resolve()
    until = next((int(a.split("=", 1)[1]) for a in sys.argv[2:] if a.startswith("--until=")), None)
    cfg = runpy.run_path(str(talk / "talk.py"))
    key = f'{cfg["KEY_NAME"]}.key'
    slides = []
    for line in osa(DUMP % key).strip().splitlines():
        n, imgs, big, count, first = line.split("|", 4)
        slides.append(weight(imgs, int(big), int(count), first))

    deck.TALK_MIN = cfg["SLOT_MIN"] - cfg["QA_MIN"]
    timed = slides[:until] if until else slides
    scale = deck.TALK_MIN / sum(timed)
    run, deck.TIMING = 0.0, []
    for n, w in enumerate(slides, 1):
        run = run + w * scale if (not until or n <= until) else deck.TALK_MIN
        deck.TIMING.append(min(run, deck.TALK_MIN))
    deck.DECK = slides                      # render_bars only needs the count
    deck.GEN = talk / "keyassets"
    deck.render_bars()

    swaps = []
    for n in range(1, len(slides) + 1):
        png = deck.GEN / f"prog-{n}.png"
        swaps.append(f"""
    tell slide {n} of d
      repeat with i from (count of images) to 1 by -1
        set im to image i
        if (file name of im) starts with "prog-" then
          set p to position of im
          delete im
          make new image with properties {{file:(POSIX file "{png}"), position:p, width:{deck.PROG_W}, height:{deck.PROG_H}}}
          exit repeat
        end if
      end repeat
    end tell""")
    osa(f'tell application "Keynote"\n  set d to document "{key}"' + "".join(swaps) + "\nend tell")
    print(f"{len(slides)} slides, {deck.TALK_MIN} min: "
          + " ".join(f"{n}:{m:.0f}" for n, m in enumerate(deck.TIMING, 1)))


if __name__ == "__main__":
    main()
