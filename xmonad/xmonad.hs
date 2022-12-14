-- XMONAD CONFIG

--
-- [ Imports ] --------------------------------------------------------
--

import XMonad

import XMonad.Hooks.EwmhDesktops

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks (manageDocks) -- no overlap bar
import XMonad.Hooks.InsertPosition -- spawn below

import XMonad.Hooks.ManageHelpers (isDialog) -- startup

import XMonad.Util.EZConfig (additionalKeysP) -- keys
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce (spawnOnce) -- startup
import XMonad.Util.Loggers

import XMonad.Actions.CycleWS (toggleWS, nextWS, prevWS, emptyWS, moveTo, Direction1D(Next,Prev), WSType(Not, NonEmptyWS))
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
  , ("M-o l"  , spawn "librewolf"		)
  , ("M-o f"  , spawn "firefox-bin"	)
  , ("M-o d"  , spawn "discord"		)
  , ("M-o s"  , spawn "steam"			)
  , ("M-o m"  , spawn "spotify"		)
  , ("M-o p"  , spawn "keepassxc"		)
  , ("M-o k"  , spawn "krita"			)
  , ("M-o e"  , spawn "emacs"			)

	-- workspaces and windows
	, ("M-<Tab>", toggleWS				)
	, ("M-n"	, toggleWS				)
	, ("M-m"	, toggleWS				)
	, ("M-l"	, nextWS				)
	, ("M-h"	, prevWS				)
	, ("M-S-l"	, sendMessage Expand	)
	, ("M-S-h"	, sendMessage Shrink	)
	, ("M-S-<Return>", windows W.swapMaster)
	, ("M-S-m", windows W.swapMaster)
	, ("M-u"	, moveTo Prev NonEmptyWS)
	, ("M-i"	, moveTo Next NonEmptyWS)

	-- misc
	, ("M-<Return>"	, spawn (myTerminal) )
	, ("M-b"		, gotoMenu )
	, ("M-q"        , spawn "xmonad --recompile; killall xmobar; xmonad --restart" )

	-- don't know what this does, move it elsewhere (originally M-n)
	, ("M-S-n"	, refresh	)

	-- system keys
	, ("<XF86MonBrightnessUp>"   , spawn "light -A 5")
	, ("<XF86MonBrightnessDown>" , spawn "light -U 5")
	, ("<XF86AudioRaiseVolume>"  , spawn "pactl set-sink-volume 0 +5%")
	, ("<XF86AudioLowerVolume>"  , spawn "pactl set-sink-volume 0 -5%")
	, ("<XF86AudioMute>"         , spawn "pactl set-sink-mute 0 toggle")

	-- view and shift to workspace 0
	, ("M-0"	, windows $ W.greedyView "0")
	, ("M-S-0"	, windows $ W.shift      "0")

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
--, className =? "KeePassXC" --> doShift ( myWorkspaces !! 8 )
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
  , layoutHook         = myLayout  -- Use custom layouts
  , manageHook         = insertPosition Above Newer <> myManageHook <+> manageDocks
  , startupHook        = myStartupHook
  , logHook            = myLogHook
  } `additionalKeysP` myKeys
