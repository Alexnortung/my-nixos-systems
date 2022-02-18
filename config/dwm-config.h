/* See LICENSE file for copyright and license details. */

/* 
    You obviously need the X11 development package installed, but here is the upstream copy
    of this header if you can't bother using the contents of your own hard drive. ;-P
    https://cgit.freedesktop.org/xorg/proto/x11proto/tree/XF86keysym.h
*/

#include <X11/XF86keysym.h>

// Volume buttons
static const char *upvol[]   = { "amixer", "set", "Master", "3%+",     NULL };
static const char *downvol[] = { "amixer", "set", "Master", "3%-",     NULL };
static const char *unmutevol[] = { "amixer", "set", "Master", "unmute",     NULL };
static const char *mutevol[] = { "amixer", "set", "Master", "toggle", NULL };

static const char *mic_mute_toggle[] = { "amixer", "set", "Capture", "toggle", NULL };

// Media buttons
static const char *media_playpause_cmd[] = { "playerctl", "play-pause", NULL };
static const char *media_next_cmd[] = { "playerctl", "next", NULL};
static const char *media_previous_cmd[] = { "playerctl", "previous", NULL};
static const char *media_stop_cmd[] = { "playerctl", "stop", NULL};
static const char *monitor_brightness_up_cmd[] = { "brightnessctl", "set", "+5%", NULL };
static const char *monitor_brightness_down_cmd[] = { "brightnessctl", "set", "5%-", NULL };

// Start programs
static const char *open_firefox_cmd[] = { "firefox", NULL };
static const char *open_flameshot_cmd[] = { "flameshot", "gui", NULL };

// Lock, shutdown, suspend, hibernate
static const char *suspend_cmd[] =  { "systemctl", "suspend", NULL };
static const char *hibernate_cmd[] =  { "systemctl", "hibernate", NULL };
static const char *poweroff_cmd[] =  { "poweroff", NULL };
static const char *reboot_cmd[] =  { "reboot", NULL };

// dmenu
static const char *emojipick_cmd[] = { "emojipick", NULL };

// Systray
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
/* appearance */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Hasklig:size=12", "TerminessTTF Nerd Font:size=12" };
static const char dmenufont[]       = "Hasklig:size=12";
static const char nord0[]  = "#2e3440";
static const char nord1[]  = "#3b4252";
static const char nord2[]  = "#434c5e";
static const char nord3[]  = "#4c566a";
static const char nord4[]  = "#d8dee9";
static const char nord5[]  = "#e5e9f0";
static const char nord6[]  = "#eceff4";
static const char nord7[]  = "#8fbcbb";
static const char nord8[]  = "#88c0d0";
static const char nord9[]  = "#81a1c1";
static const char nord10[] = "#5e81ac";
static const char nord11[] = "#bf616a";
static const char nord12[] = "#d08770";
static const char nord13[] = "#ebcb8b";
static const char nord14[] = "#a3be8c";
static const char nord15[] = "#b48ead";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	//[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeNorm] = { nord5, nord0, nord1 },
	//[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
	[SchemeSel]  = { nord0, nord8,  nord8  },
};

// BAR
//static const int showbar       = 1;          /* 0 means no bar */
//static const int topbar        = 1;          /* 0 means bottom bar */
//static const int usealtbar     = 1;          /* 1 means use non-dwm status bar */
//static const char *altbarclass = "Polybar";  /* Alternate bar class name */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	//{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	//{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
	{}
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
//#define MODKEY Mod1Mask
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", nord0, "-nf", nord5, "-sb", nord8, "-sf", nord0, NULL };
static const char *termcmd[]  = { "st", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_End,      quit,           {0} }, // do not quit
    /* With 0 as modifier, you are able to use the keys directly */
    { 0,                       XF86XK_AudioLowerVolume, spawn, {.v = downvol } },
    { 0,                       XF86XK_AudioLowerVolume, spawn, {.v = unmutevol } },
    { 0,                       XF86XK_AudioMute, spawn, {.v = mutevol } },
    { 0,                       XF86XK_AudioRaiseVolume, spawn, {.v = upvol   } },
    { 0,                       XF86XK_AudioRaiseVolume, spawn, {.v = unmutevol   } },
    { 0,                       XF86XK_AudioMicMute, spawn, {.v = mic_mute_toggle   } },
    // Media keys
    { 0, XF86XK_AudioPlay, spawn, {.v = media_playpause_cmd } },
    { 0, XF86XK_AudioNext, spawn, {.v = media_next_cmd } },
    { 0, XF86XK_AudioPrev, spawn, {.v = media_previous_cmd } },
    { 0, XF86XK_AudioStop, spawn, {.v = media_stop_cmd } },
    { 0, XF86XK_MonBrightnessUp, spawn, {.v = monitor_brightness_up_cmd } },
    { 0, XF86XK_MonBrightnessDown, spawn, {.v = monitor_brightness_down_cmd } },
    // Open programs
    { MODKEY, XK_F2, spawn, {.v = open_firefox_cmd} },
    { 0, XK_Print, spawn, {.v = open_flameshot_cmd} },
    // Power
    { MODKEY, XK_F9, spawn, {.v = suspend_cmd } },
    { MODKEY, XK_F10, spawn, {.v = hibernate_cmd } },
    { MODKEY|ShiftMask, XK_F12, spawn, {.v = poweroff_cmd } },
    { MODKEY|ShiftMask, XK_F11, spawn, {.v = reboot_cmd } },
    { MODKEY|ControlMask, XK_period, spawn, { .v = emojipick_cmd } }
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
