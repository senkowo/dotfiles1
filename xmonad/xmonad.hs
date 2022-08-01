
-- 
-- Xmonad Config       .  .  .  . . . . . . . . .. .............
--

import XMonad

import XMonad.Hooks.EwmhDesktops

import XMonad.Hooks.DynamicLog 
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks (manageDocks) -- no overlap bar

import XMonad.Hooks.ManageHelpers (isDialog) -- startup

import XMonad.Util.EZConfig (additionalKeysP) -- keys
import XMonad.Util.Ungrab 
import XMonad.Util.SpawnOnce (spawnOnce) -- startup
import XMonad.Util.Loggers

import XMonad.Actions.CycleWS (toggleWS, nextWS, prevWS)
import XMonad.Actions.WindowBringer

import XMonad.Layout.NoBorders (smartBorders)

import qualified XMonad.StackSet as W


--
-- Configuration 
--


myTerminal :: String
myTerminal = "urxvtc"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myNormalColor :: String
myNormalColor = "#040a0a"

myFocusedColor :: String
myFocusedColor = "#1e9c8f"
-- #1e9c8f
-- #157b8f
--


--
------------------------------------------------------------------
--


myKeys :: [(String, X ())]
myKeys = 
	[ ("M-S-z", spawn "xscreensaver-command -lock")
	, ("M-C-s", unGrab *> spawn "scrot -s -f -l style=dash '/home/senko/Pictures/Screenshots/%F-%T-$wx$h.png' -e 'xclip -selection clipboard -target image/png -in $f'")

	-- spawn applications using emacs-keybindings
	, ("M-u l"  , spawn "librewolf"		)
	, ("M-u s"  , spawn "steam"			)
	, ("M-u d"  , spawn "discord"		)
	, ("M-u k"  , spawn "keepassxc"		)
	, ("M-u f"  , spawn "firefox-bin"	)
	, ("M-u m"  , spawn "spotify"		)

	-- workspaces and windows
	, ("M-<Tab>", toggleWS				)
	, ("M-l"	, nextWS				)
	, ("M-h"	, prevWS				)
	, ("M-S-l"	, sendMessage Expand	)
	, ("M-S-h"	, sendMessage Shrink	)
	, ("M-S-<Return>", windows W.swapMaster)
	, ("M-S-m", windows W.swapMaster)

	-- misc
	, ("M-<Return>"	, spawn (myTerminal) )
	, ("M-i"		, gotoMenu )
	, ("M-q"        , spawn "xmonad --recompile; killall xmobar; xmonad --restart" )

	-- don't know what this does, move it elsewhere (originally M-n)
	, ("M-S-n"	, refresh	)

	-- system keys
	, ("<XF86MonBrightnessUp>"   , spawn "xbacklight +10")
	, ("<XF86MonBrightnessDown>" , spawn "xbacklight -10")
	, ("<XF86AudioRaiseVolume>"  , spawn "pactl set-sink-volume 0 +5%")
	, ("<XF86AudioLowerVolume>"  , spawn "pactl set-sink-volume 0 -5%")
	, ("<XF86AudioMute>"         , spawn "pactl set-sink-mute 0 toggle")
	]


--
------------------------------------------------------------------
--

-- use xprop

myManageHook :: ManageHook
myManageHook = composeAll
	[ className =? "Gimp"	   --> doFloat
	, isDialog				   --> doFloat
	, className =? "librewolf" --> doShift ( myWorkspaces !! 1 )
	, className =? "discord"   --> doShift ( myWorkspaces !! 3 )
	, className =? "Steam"     --> doShift ( myWorkspaces !! 4 )
	, className =? "firefox"   --> doShift ( myWorkspaces !! 7 )
	, className =? "KeePassXC" --> doShift ( myWorkspaces !! 8 )
	]

--
------------------------------------------------------------------
--


myLayout = smartBorders $ tiled ||| Mirror tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

myStartupHook :: X ()
myStartupHook = do
	spawn "killall trayer"
	spawn "sleep 0.5 && trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 30 --tint 0x000000 --height 10"
	spawnOnce "xscreensaver -no-splash"
--	spawnOnce "nm-applet"
	spawnOnce "dropbox"


--
------------------------------------------------------------------
--


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
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


--
------------------------------------------------------------------
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
	{ modMask			 = mod4Mask  -- Rebind Mod to the Super key
	, focusFollowsMouse	 = myFocusFollowsMouse
	, workspaces		 = myWorkspaces
	, normalBorderColor	 = myNormalColor
	, focusedBorderColor = myFocusedColor
	, terminal			 = myTerminal	 -- Set terminal
	, manageHook		 = myManageHook <+> manageDocks
	, layoutHook		 = myLayout  -- Use custom layouts
	, startupHook		 = myStartupHook
	} `additionalKeysP` myKeys



