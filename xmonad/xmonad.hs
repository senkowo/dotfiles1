-- XMONAD CONFIG

--
-- [ Imports ] --------------------------------------------------------
--

import XMonad

import XMonad.Hooks.EwmhDesktops --ewmh

import XMonad.Hooks.DynamicLog --deprecated compatibility wrapper for StatusBar
import XMonad.Hooks.StatusBar --output info to xmobar
import XMonad.Hooks.StatusBar.PP --pretty print xmobar
import XMonad.Hooks.ManageDocks (manageDocks) --no overlap bar, manage bar
import XMonad.Hooks.InsertPosition --spawn below
import XMonad.Hooks.ManageHelpers (isDialog) --if-do, helpers for ManageHook
import XMonad.Hooks.RefocusLast (refocusLastLayoutHook, toggleFocus) --toggle to previous window

import XMonad.Util.EZConfig (additionalKeysP) --keys
import XMonad.Util.Ungrab --release keyboard grab
import XMonad.Util.SpawnOnce (spawnOnce) --only on startup and ignore again
import XMonad.Util.Loggers --ppExtras extra formatting + loggers

--                             toggle    next    prev    moveTo  Data Next/Prev          Not          isEmpty  WinMoveToAdjacent
import XMonad.Actions.CycleWS (toggleWS, nextWS, prevWS, moveTo, Direction1D(Next,Prev), WSType(Not), emptyWS, shiftToNext, shiftToPrev)
import XMonad.Actions.WindowBringer (gotoMenu) -- for search for windows dmeunu
import XMonad.Actions.UpdatePointer -- for warp clone

import XMonad.Layout.NoBorders (smartBorders) -- smartborders

import qualified XMonad.StackSet as W

--
-- [ Settings ] -------------------------------------------------------
--

myTerminal :: String
myTerminal = "urxvtc"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- note: workspace 0 added. access to implemented through keybinds below.
myWorkspaces = ["1","2","3","4","5","6","7","8","9","0"]

myNormalColor :: String
myNormalColor = "#040a0a"

myFocusedColor :: String
myFocusedColor = "#1e9c8f"
-- #1e9c8f
-- #157b8f
--

--
-- [ Keys ] -----------------------------------------------------------
--

myKeys :: [(String, X ())]
myKeys =
  [ ("M-S-z", spawn "xscreensaver-command -lock")
  , ("M-C-s", unGrab *> spawn "scrot -s -f -l style=dash '/home/senko/Pictures/Screenshots/%F-%T-$wx$h.png' -e 'xclip -selection clipboard -target image/png -in $f'")
  , ("M-v b", spawn "pomo.sh start"       )
  , ("M-v s", spawn "pomo.sh stop"        )
  , ("M-v p", spawn "pomo.sh pause"       )
  , ("M-v r", spawn "pomo.sh restart"     )

  -- spawn applications using emacs-keybindings
  , ("M-o l"  , spawn "librewolf"         )
  , ("M-o f"  , spawn "firefox-bin"       )
  , ("M-o d"  , spawn "discord"           )
  , ("M-o s"  , spawn "steam"             )
  , ("M-o m"  , spawn "spotify"           )
  , ("M-o p"  , spawn "keepassxc"         )
  , ("M-o k"  , spawn "krita"             )
  , ("M-o M-o"  , spawn "emacsclient -c -a ''")

  -- << workspaces, layout, and windows >>
  -- workspaces
  , ("M-<Tab>", toggleWS      )
  , ("M-m"  , toggleWS        )
  , ("M-l"  , nextWS          )
  , ("M-h"  , prevWS          )
  , ("M-u"  , moveTo Prev (Not emptyWS))
  , ("M-i"  , moveTo Next (Not emptyWS))
  -- layout
  , ("M-S-u"  , sendMessage Shrink  )
  , ("M-S-i"  , sendMessage Expand  )
  -- window move workspace
  , ("M-S-h" , shiftToPrev)
  , ("M-S-l" , shiftToNext)
  -- window focus
  , ("M-n"  , toggleFocus)
  -- window move local
  , ("M-S-<Return>", windows W.swapMaster)
  , ("M-S-m"       , windows W.swapMaster)
  -- TEST
  , ("M-C-h" , moveTo Prev (emptyWS))
  , ("M-C-l" , moveTo Next (emptyWS))

  -- misc
  , ("M-<Return>"  , spawn (myTerminal) )
  , ("M-b"   , gotoMenu )
  , ("M-q"   , spawn "xmonad --recompile; killall xmobar; xmonad --restart" )

  -- don't know what this does, move it elsewhere (originally M-n)
  , ("M-S-n"  , refresh  )

  -- system keys
  , ("<XF86MonBrightnessUp>"   , spawn "light -A 5")
  , ("<XF86MonBrightnessDown>" , spawn "light -U 5")
  , ("<XF86AudioRaiseVolume>"  , spawn "pactl set-sink-volume 0 +5%")
  , ("<XF86AudioLowerVolume>"  , spawn "pactl set-sink-volume 0 -5%")
  , ("<XF86AudioMute>"         , spawn "pactl set-sink-mute 0 toggle")

  -- view and shift to workspace 0
  , ("M-0"    , windows $ W.greedyView "0")
  , ("M-S-0"  , windows $ W.shift      "0")

  ]

--
-- [ ManageHook ] -----------------------------------------------------
--

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Gimp"	   --> doFloat
  , isDialog				   --> doFloat
--, className =? "librewolf" --> doShift ( myWorkspaces !! 6 )
--, className =? "discord"   --> doShift ( myWorkspaces !! 3 )
--, className =? "Steam"     --> doShift ( myWorkspaces !! 4 )
--, className =? "firefox"   --> doShift ( myWorkspaces !! 7 )
  , className =? "KeePassXC" --> doShift ( myWorkspaces !! 8 )
--, className =? "krita"     --> doShift ( myWorkspaces !! 9 )
  ]

--
-- [ Layout ] ---------------------------------------------------------
--

myLayout = smartBorders $ tiled ||| Mirror tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

--
-- [ Startup ] --------------------------------------------------------
--

myStartupHook :: X ()
myStartupHook = do
  spawn "killall trayer"
  spawn "sleep 0.5 && trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 30 --tint 0x000000 --height 11"
  spawnOnce "xscreensaver -no-splash"
--spawnOnce "dropbox"

--
-- [ LogHook ] --------------------------------------------------------
--

myLogHook :: X ()
myLogHook = updatePointer (0.5, 0.5) (0, 0)

--
-- [ Xmobar ] ---------------------------------------------------------
--

myXmobarPP :: PP
myXmobarPP = def
{-    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
-}

--
-- [ Main ] -----------------------------------------------------------
--

main :: IO ()
main = xmonad
  . ewmhFullscreen
  . ewmh
  . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure def)) toggleStrutsKey
  $ myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m.|.shiftMask, xK_t)

myConfig = def
  { modMask            = mod4Mask  -- Rebind Mod to the Super key
  , terminal           = myTerminal -- Set terminal
  , focusFollowsMouse  = myFocusFollowsMouse
  , workspaces         = myWorkspaces
  , normalBorderColor  = myNormalColor
  , focusedBorderColor = myFocusedColor
  , layoutHook         = refocusLastLayoutHook $ myLayout
  , manageHook         = insertPosition Below Newer <> myManageHook <+> manageDocks
  , startupHook        = myStartupHook
  , logHook            = myLogHook
  } `additionalKeysP` myKeys
