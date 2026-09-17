-- Builds the Keynote master for the Rolle speaker base.
-- Run: osascript scripts/build-key.applescript
-- Bitmaps it needs live in build/keyassets and are produced by scripts/build-assets.sh.

set repoRoot to (do shell script "cd " & quoted form of ((POSIX path of (path to home folder)) & "Projects/keynote-base") & " && pwd")
set assetDir to repoRoot & "/build/keyassets/"
set outPath to repoRoot & "/build/Rolle speaker base.key"

-- Palette, 16-bit channels
set inkColor to {6425, 2056, 13364} -- #190834
set violetColor to {19532, 7453, 38293} -- #4C1D95
set subtitleColor to {14906, 8738, 16448} -- #3A2240
set secondaryColor to {19018, 15420, 20046} -- #4A3C4E
set bodyColor to {11822, 6939, 13364} -- #2E1B34
set panelInkColor to {11051, 6939, 13107} -- #2B1B33

tell application "Keynote"
  activate
  set doc to make new document with properties {width:1920, height:1080}
  tell doc
    set blankMaster to master slide "Blank"
    set base slide of slide 1 to blankMaster
    set s2 to make new slide with properties {base slide:blankMaster}
    set s3 to make new slide with properties {base slide:blankMaster}

    -- ---------- Slide 1, cover ----------
    tell slide 1
      make new image with properties {file:(POSIX file (assetDir & "bg.png")), position:{0, 0}, width:1920, height:1080}
      make new image with properties {file:(POSIX file (repoRoot & "/assets/portrait-crop.jpg")), position:{1461, 0}, width:459, height:1080}
      make new image with properties {file:(POSIX file (assetDir & "mindtrek.png")), position:{108, 86}, width:240, height:31}
      make new image with properties {file:(POSIX file (assetDir & "icons.png")), position:{108, 972}, width:353, height:32}

      set t1 to make new text item with properties {object text:"Mindtrek 2026, Tampere, 6th of October, 2026", position:{372, 84}, width:900, height:40}
      tell object text of t1
        set its font to "Geist-Medium"
        set its size to 29
        set its color to violetColor
      end tell

      set t2 to make new text item with properties {object text:"Sovereign", position:{108, 287}, width:1100, height:150}
      tell object text of t2
        set its font to "Unbounded-Regular_ExtraBold"
        set its size to 138
        set its color to inkColor
      end tell

      set t3 to make new text item with properties {object text:"by habit", position:{108, 401}, width:1100, height:180}
      tell object text of t3
        set its font to "InstrumentSerif-Italic"
        set its size to 174
        set its color to violetColor
      end tell

      -- Two items, because Keynote leads multi-line text far looser than the browser.
      set t4 to make new text item with properties {object text:"20 years of self-hosting from source", position:{108, 597}, width:1100, height:52}
      tell object text of t4
        set its font to "Geist-Regular"
        set its size to 38
        set its color to subtitleColor
      end tell

      set t4b to make new text item with properties {object text:"on European servers", position:{108, 649}, width:1100, height:52}
      tell object text of t4b
        set its font to "Geist-Regular"
        set its size to 38
        set its color to subtitleColor
      end tell

      set t5 to make new text item with properties {object text:"Rolle Laukkarinen", position:{108, 864}, width:1100, height:48}
      tell object text of t5
        set its font to "Geist-SemiBold"
        set its size to 36
        set its color to inkColor
      end tell

      set t6 to make new text item with properties {object text:"Founder and CTO, Digitoimisto Dude Oy", position:{108, 912}, width:1100, height:40}
      tell object text of t6
        set its font to "Geist-Regular"
        set its size to 29
        set its color to secondaryColor
      end tell

      set t7 to make new text item with properties {object text:"rolle.social", position:{491, 966}, width:500, height:42}
      tell object text of t7
        set its font to "Geist-Medium"
        set its size to 30
        set its color to secondaryColor
      end tell
    end tell

    -- ---------- Slide 2, content ----------
    tell s2
      make new image with properties {file:(POSIX file (assetDir & "bg.png")), position:{0, 0}, width:1920, height:1080}

      set h2a to make new text item with properties {object text:"Where it still", position:{108, 96}, width:1000, height:135}
      tell object text of h2a
        set its font to "Unbounded-Regular_ExtraBold"
        set its size to 102
        set its color to inkColor
      end tell

      set h2b to make new text item with properties {object text:"leaks", position:{966, 80}, width:600, height:175}
      tell object text of h2b
        set its font to "InstrumentSerif-Italic"
        set its size to 132
        set its color to violetColor
      end tell

      set labels to {"DNS", "CDN", "Email", "AI APIs"}
      set bodies to {"Registrar and resolver are somebody else's uptime.", "The edge in front of your origin is not your edge.", "Deliverability belongs to the big mailbox providers.", "The newest dependency, and the least portable one."}
      repeat with i from 1 to 4
        if i is 1 then
          set px to 108
          set py to 269
        else if i is 2 then
          set px to 1014
          set py to 269
        else if i is 3 then
          set px to 108
          set py to 510
        else
          set px to 1014
          set py to 510
        end if
        set lb to make new text item with properties {object text:(item i of labels), position:{px, py}, width:798, height:70}
        tell object text of lb
          set its font to "Unbounded-Regular_SemiBold"
          set its size to 51
          set its color to violetColor
        end tell
        set bd to make new text item with properties {object text:(item i of bodies), position:{px, py + 76}, width:798, height:125}
        tell object text of bd
          set its font to "Geist-Regular"
          set its size to 39
          set its color to bodyColor
        end tell
      end repeat

      set p1 to make new text item with properties {object text:"13", position:{1752, 946}, width:60, height:40}
      tell object text of p1
        set its font to "Geist-Regular"
        set its size to 26
        set its color to secondaryColor
      end tell

      set f1 to make new text item with properties {object text:"Sovereign by habit", position:{108, 946}, width:900, height:40}
      tell object text of f1
        set its font to "Geist-Regular"
        set its size to 26
        set its color to secondaryColor
      end tell
    end tell

    -- ---------- Slide 3, code ----------
    tell s3
      make new image with properties {file:(POSIX file (assetDir & "bg.png")), position:{0, 0}, width:1920, height:1080}
      make new image with properties {file:(POSIX file (assetDir & "panel-left.png")), position:{108, 326}, width:819, height:110}
      make new image with properties {file:(POSIX file (assetDir & "panel-right.png")), position:{993, 326}, width:819, height:440}

      set h3a to make new text item with properties {object text:"One field,", position:{108, 96}, width:1000, height:135}
      tell object text of h3a
        set its font to "Unbounded-Regular_ExtraBold"
        set its size to 102
        set its color to inkColor
      end tell

      set h3b to make new text item with properties {object text:"two ways", position:{796, 80}, width:700, height:175}
      tell object text of h3b
        set its font to "InstrumentSerif-Italic"
        set its size to 132
        set its color to violetColor
      end tell

      set l1 to make new text item with properties {object text:"With the plugin", position:{108, 247}, width:819, height:70}
      tell object text of l1
        set its font to "InstrumentSerif-Regular"
        set its size to 51
        set its color to violetColor
      end tell

      set l2 to make new text item with properties {object text:"With core", position:{993, 247}, width:819, height:70}
      tell object text of l2
        set its font to "InstrumentSerif-Regular"
        set its size to 51
        set its color to violetColor
      end tell

      set c1 to make new text item with properties {object text:"the_field( 'subtitle' );", position:{147, 326}, width:760, height:110}
      tell object text of c1
        set its font to "GeistMono-Regular"
        set its size to 28
        set its color to panelInkColor
      end tell

      set codeTwo to "register_post_meta( 'post', 'subtitle', [" & return & "  'type'         => 'string'," & return & "  'single'       => true," & return & "  'show_in_rest' => true," & return & "] );"
      set c2 to make new text item with properties {object text:codeTwo, position:{1032, 326}, width:800, height:440}
      tell object text of c2
        set its font to "GeistMono-Regular"
        set its size to 28
        set its color to panelInkColor
      end tell

      set tk to make new text item with properties {object text:"Four more lines, and the value now has a type, a schema and a REST route. The theme stops being the only thing that knows the field exists.", position:{108, 800}, width:1560, height:120}
      tell object text of tk
        set its font to "Geist-Regular"
        set its size to 38
        set its color to bodyColor
      end tell

      set p2 to make new text item with properties {object text:"7", position:{1762, 946}, width:50, height:40}
      tell object text of p2
        set its font to "Geist-Regular"
        set its size to 26
        set its color to secondaryColor
      end tell

      set f2 to make new text item with properties {object text:"Going ACF-free", position:{108, 946}, width:900, height:40}
      tell object text of f2
        set its font to "Geist-Regular"
        set its size to 26
        set its color to secondaryColor
      end tell
    end tell

    save doc in POSIX file outPath
  end tell
end tell
