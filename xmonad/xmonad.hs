
--
-- Imports 
-------------

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Hooks.ManageDocks -- xmobar no longer behind
import XMonad.Hooks.DynamicLog -- xmobar workspaces; output info to bar
import XMonad.Util.Run -- spawnPipe
import XMonad.Util.SpawnOnce -- spawnOnce
import XMonad.Actions.SpawnOn -- spawn apps in certain wkspaces
import XMonad.Actions.CycleWS -- toggle workspaces
import XMonad.Layout.Spacing -- gaps
import Graphics.X11.ExtraTypes.XF86 -- XF86 keys
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- 
-- General
-------------

myTerminal      = "urxvt"

myFocusFollowsMouse :: Bool -- Whether focus follows the mouse pointer.
myFocusFollowsMouse = False

myClickJustFocuses :: Bool -- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False

myBorderWidth   = 2 -- Width of the window border in pixels.

myModMask       = mod4Mask

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#a8bfbc" -- ( unfocused
myFocusedBorderColor = "#57bd61" -- ( focused
-- #dddddd
-- #53b858
-- #57bd61
-- #74a4ab
-- #94b0a8
-- #4e9671
-- #87b356
-- #808080
-- #549c77
-- #b4c2c0
-- #a8bfbc
-- #a5b5b3
-- #819691

--
-- Key bindings 
-------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm,				xK_Return), spawn $ XMonad.terminal conf) -- launch a terminal

    , ((modm,               xK_p     ), spawn "dmenu_run") -- launch dmenu

    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun") -- launch gmrun

	, ((0 ,   xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")

	, ((0 ,   xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

	, ((0 ,          xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

	, ((0 ,    xF86XK_MonBrightnessUp), spawn "xbacklight +10")

	, ((0 ,  xF86XK_MonBrightnessDown), spawn "xbacklight -10")

    , ((modm .|. shiftMask, xK_c     ), kill) -- close focused window

    , ((modm,               xK_space ), sendMessage NextLayout) -- Rotate through the available layout algorithms

    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) --  Reset the layouts on the current workspace to default

    , ((modm,               xK_n     ), refresh) -- Resize viewed windows to the correct size

    , ((modm,               xK_Tab   ), toggleWS) -- Move focus to the next window

    , ((modm,               xK_j     ), windows W.focusDown) -- Move focus to the next window

    , ((modm,               xK_k     ), windows W.focusUp  ) -- Move focus to the previous window

    , ((modm,               xK_m     ), windows W.focusMaster  ) -- Move focus to the master window

    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster) -- Swap the focused window and the master window

    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  ) -- Swap the focused window with the next window

    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    ) -- Swap the focused window with the previous window

    , ((modm,               xK_h     ), sendMessage Shrink) -- Shrink the master area

    , ((modm,               xK_l     ), sendMessage Expand) -- Expand the master area

    , ((modm,               xK_t     ), withFocused $ windows . W.sink) -- Push window back into tiling

    , ((modm              , xK_comma ), sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area

    , ((modm              , xK_period), sendMessage (IncMasterN (-1))) -- Deincrement the number of windows in the master area

	, ((modm			  , xK_b	 ), sendMessage ToggleStruts) -- toggle status bar

    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- Quit xmonad

    , ((modm              , xK_q     ), spawn "xmonad --recompile; killall xmobar; xmonad --restart") -- Restart xmonad

    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- message of default keybinds
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

myLayout = smartSpacing 4
  $avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
		spawnOnce "~/.local/bin/pipewire-start.sh &"
		spawnOnce "~/.fehbg &"
		spawnOnce "picom --experimental-backends &"
		spawnOnce "xsetroot -cursor_name left_ptr &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
		xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobar-conf"
		xmonad $ docks $ def {

      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
--		logHook            = myLogHook,
		logHook = dynamicLogWithPP $ xmobarPP 
				{ ppOutput = hPutStrLn xmproc
				, ppSep = "   "
				, ppOrder = \(ws:_) -> [ws]
				},
        startupHook        = myStartupHook
	}

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
