#include <X11/XF86keysym.h>
#include "colors.h"
/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 8;		/* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 1;   	/* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 8;   /* systray spacing */
static const unsigned int systraypadding = 16;  /* space btw systray and status bar */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;		/* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char buttonbar[]       = "󰣇"; //󰣇   /* Empty string means no button */
static const int user_bh            = 0;        /* 0 means that dwm will calculate bar height */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int hidevacanttags		= 1;		/* Hide vacant tags and remove rectangle indicators */
static const int floathighlight		= 0;		/* Use different border color for floating window */
static const int floattitlecolor	= 1;		/* Use different title color for floating window */

static const char *fonts[]          = { "Berkeley Mono:style=Medium:size=12", "Material Design Icons:size=12" };
static const char dmenufont[]       = "Berkeley Mono:size=12";

static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static const int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int underlinetags		= 1;		/* enable tag underline */
static const unsigned int ulinepad	= 2;		/* horizontal padding between the underline and tag */
static const unsigned int ulinestroke	= 2;	/* thickness / height of the underline */
static const unsigned int ulinevoffset	= 0;	/* how far above the bottom of the bar the line should appear */
static const int ulineall			= 0;		/* 1 to show underline on all non empty tags */

/* tagging */
// static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const char *tags[] = { "1  :  󰚺", "2  :  󰈹", "3  :  󰇮", "4  :  󰨞", "5", "6", "7", "8  :  󰔁", "9  :  󰓇" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class     			instance     		title          tags mask   isfloating  	isterminal  noswallow  monitor */
	{ NULL,       			NULL,       		"Event Tester",0,            0,        	0,          1,         	-1 }, // xev
	{ "Alacritty",			NULL,       		NULL,          0,            0,        	1,          0,         	-1 },
	{ "st-256color",		NULL,       		NULL,          0,            0,        	1,          0,         	-1 },
	{ "Thunar",				NULL,				NULL,		   0,			 1,			0,			0,			-1 },
	{ "Pavucontrol", 		NULL,   			NULL, 		   0,    		 1, 		0, 			0,			-1 },
	{ "SimpleScreenRecorder",	NULL,			NULL,		   0,			 1,			0,			0,			-1 },
	{ "Nm-connection-editor", 	NULL,			NULL, 		   0,    		 1, 		0, 			0,			-1 },
	{ "TelegramDesktop", 	"telegram-desktop", "Media viewer",0,			 1, 		0, 		 	1, 			-1 }, // telegram media viewer
	{ "firefox", 			"Toolkit",   		"Picture-in-Picture", 0,     1, 		0, 			0,			-1 },
	{ "Protonvpn",			"protonvpn",		NULL, 		   0,    		 1, 		0, 			0,			-1 },
	{ "firefox",			"Navigator",		NULL, 		   1<<1,    	 0, 		0, 			0,			-1 },
	{ "Google-chrome",		"google-chrome",	NULL, 		   1<<2,    	 0, 		0, 			0,			-1 },
	{ "LibreWolf",			"Navigator",		NULL, 		   1<<6,    	 0, 		0, 			0,			-1 },
	{ "TelegramDesktop",	"telegram-desktop",	NULL, 		   1<<7,    	 0, 		0, 			0,			-1 },
	{ "Spotify",			"spotify",			NULL, 		   1<<8,    	 0, 		0, 			0,			-1 },
};

/* layout(s) */
static const float mfact     = 0.495; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "Tile",     tile },    /* first entry is default */
	{ "Float",    NULL },    /* no layout function means floating behavior */
	{ "Max",      monocle },
	{ "Deck",     deck },
	{ "BStack",	  bstack },
	{ NULL,       NULL },	 /* for cycle layouts */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
//	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]  = { "dmenu_run", "-i", NULL };
static const char *dmenuhcmd[] = { "dmenu_hist", "-i", NULL };
static const char *lock[]      = { "screenoff", NULL };
static const char *powermenu[] = { "powermenu", NULL };
static const char *winlist[]   = { "winlist", NULL };
static const char *termcmd[]   = { "alacritty", NULL };
static const char *termcmd2[]  = { "st", NULL };
static const char *browser[]   = { "firefox-nightly", NULL };
static const char *discord[]   = { "discord", NULL };
static const char *pavu[]      = { "pavucontrol", NULL };
static const char *flameshot[] = { "flameshot", "gui", NULL };
static const char *spotify[]   = { "spotify", NULL };
static const char *files[]     = { "thunar", NULL };
static const char *network[]   = { "nm-connection-editor", NULL };

static const char *bright_down[]   = {"brightnessctl", "set", "5%-", NULL};
static const char *bright_up[] = {"brightnessctl", "set", "5%+", NULL};

static const char *vol_up[]    = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+2%", NULL };
static const char *vol_down[]  = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-2%", NULL };
static const char *vol_mute[]  = { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };
static const char *db_vol_update[] = { "pkill", "-RTMIN+3", "dwmblocks", NULL };
static const char *db_br_update[]  = { "pkill", "-RTMIN+2", "dwmblocks", NULL };
static const char *xob_br_update[] = { "sh", "/home/rohit/.config/xob/scripts/brightness.sh", NULL };

static const char *play_tggl[] = { "python3", "/home/rohit/.config/scripts/media.py", NULL };
static const char *play_next[] = { "playerctl", "next", NULL };
static const char *play_prev[] = { "playerctl", "previous", NULL };
static const char *skippy_xd[] = { "skippy-xd", NULL };
static const char *clipmenu[]  = { "clipmenu", "-p", "Clipboard", NULL };

static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "100x25", NULL };

static Key keys[] = {
	/* modifier                     key                       function        argument */
	{ MODKEY|ShiftMask,             XK_c,                     killclient,     {0} },         // kill window
	{ MODKEY|ShiftMask,             XK_q,      				  quit,           {0} }, 		 // kill dwm
	{ MODKEY,                       XK_BackSpace,             spawn,          {.v = lock} }, // lock
	{ MODKEY,                       XK_Delete,	              spawn,          {.v = powermenu} }, // powermenu

	// open programs
	{ MODKEY,                       XK_Return,                spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_Return,                spawn,          {.v = dmenucmd } },
	{ Mod1Mask,                     XK_space,                 spawn,          {.v = winlist } },
	{ MODKEY,                       XK_e,                     spawn,          {.v = files } },
	{ MODKEY,                       XK_w,                     spawn,          {.v = browser } },
	{ MODKEY|ControlMask,           XK_p,                     spawn,          {.v = pavu } },
	{ MODKEY,                       XK_Print,                 spawn,          {.v = flameshot } },
	{ MODKEY,                       XK_x,                     spawn,          {.v = skippy_xd } },
	{ MODKEY,                       XK_v,                     spawn,          {.v = clipmenu } },
	{ MODKEY,                       XK_n,                     spawn,          {.v = network } },

	// laptop audio control
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn,          {.v = vol_up } },
	{ 0,                            XF86XK_AudioLowerVolume,  spawn,          {.v = vol_down } },
	{ 0,                            XF86XK_AudioMute,         spawn,          {.v = vol_mute } },
	{ 0,                            XF86XK_AudioRaiseVolume,  spawn,          {.v = db_vol_update } },
	{ 0,                            XF86XK_AudioLowerVolume,  spawn,          {.v = db_vol_update } },
	{ 0,                            XF86XK_AudioMute,         spawn,          {.v = db_vol_update } },
	{ 0,                            XF86XK_AudioPlay,         spawn,          {.v = play_tggl } },
	{ 0,                            XF86XK_AudioNext,         spawn,          {.v = play_next } },
	{ 0,                            XF86XK_AudioPrev,         spawn,          {.v = play_prev } },
    
    // Brightness control
    { 0,                            XF86XK_MonBrightnessUp,   spawn,          {.v = bright_up } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn,          {.v = bright_down } }, 
	{ 0,                            XF86XK_MonBrightnessUp,   spawn,          {.v = xob_br_update } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn,          {.v = xob_br_update } },    

	// window layout and control
	{ MODKEY,                       XK_f,                     setlayout,      {.v = &layouts[0]} }, // float
	{ MODKEY,                       XK_t,                     setlayout,      {.v = &layouts[1]} }, // tiling
	{ MODKEY,                       XK_m,                     setlayout,      {.v = &layouts[2]} }, // monocle
	{ MODKEY,                       XK_c,					  setlayout,      {.v = &layouts[3]} }, // deck
	{ MODKEY,				        XK_o,                     setlayout,      {.v = &layouts[4]} }, // bstack
	{ MODKEY,						XK_backslash,			  cyclelayout,    {.i = +1 } },
	{ MODKEY,						XK_p,					  togglefullscreen,    {0} },

	{ MODKEY|ShiftMask,				XK_h,                     setmfact,       {.f = -0.04} }, // decrease master size
	{ MODKEY|ShiftMask,				XK_l,                     setmfact,       {.f = +0.04} }, // increase master size

	{ MODKEY,                       XK_j,                     focusstack,     {.i = +1 } }, // focus down
	{ MODKEY,                       XK_k,                     focusstack,     {.i = -1 } }, // focus up
	{ MODKEY,                       XK_Down,                  focusstack,     {.i = +1 } }, // focus down
	{ MODKEY,                       XK_Up,                    focusstack,     {.i = -1 } }, // focus up

	{ MODKEY,                       XK_comma,                 incrgaps,       {.i = -4 } }, 
	{ MODKEY,                       XK_period,                incrgaps,       {.i = +4 } },
	{ MODKEY,                       XK_slash,                 defaultgaps,    {0} },
    
    { Mod1Mask,                     XK_Tab,                   focusstack,     {.i = +1 } }, // focus down
	{ Mod1Mask|ShiftMask,           XK_Tab,                   focusstack,     {.i = -1 } }, // focus up

	{ MODKEY,                       XK_b,                     togglebar,      {0} }, // show bar

	{ MODKEY,                       XK_i,                     incnmaster,     {.i = +1 } }, // more master nodes
	{ MODKEY,                       XK_d,                     incnmaster,     {.i = -1 } }, // less measter nodes

	{ MODKEY,                       XK_z,                     zoom,           {0} }, // zoom on selected window

    { MODKEY,                       XK_h,		              shiftviewactive,      {.i = -1 } }, // switch to prev active tag
    { MODKEY,                       XK_l,					  shiftviewactive,      {.i = +1 } }, // switch to next active tag
    { MODKEY,                       XK_Left,                  shiftview,      {.i = -1 } }, // switch to prev tag
    { MODKEY,                       XK_Right,                 shiftview,      {.i = +1 } }, // switch to next tag
	{ MODKEY|ShiftMask,             XK_Left,                  shifttag,       {.i = -1 } }, // shift win to prev tag
    { MODKEY|ShiftMask,             XK_Right,                 shifttag,       {.i = +1 } }, // shift win to next tag
    { MODKEY|ControlMask,           XK_Left,                  shifttagview,   {.i = -1 } }, // shift win and switch to prev tag
    { MODKEY|ControlMask,           XK_Right,                 shifttagview,   {.i = +1 } }, // shift win and switch to next tag
    
	{ MODKEY,                       XK_Tab,                   view,           {0} },         // view last tag
	{ MODKEY,                       XK_0,                     view,           {.ui = ~0 } }, // view all tags
	{ MODKEY|ShiftMask,             XK_0,                     tag,            {.ui = ~0 } }, // tag applications
	{ MODKEY|ShiftMask,             XK_f,					  togglefloating, {0} }, //float window
	{ MODKEY,                       XK_grave,				  togglescratch,  {.v = scratchpadcmd } },

	TAGKEYS(                        XK_1,                                     0)
	TAGKEYS(                        XK_2,                                     1)
	TAGKEYS(                        XK_3,                                     2)
	TAGKEYS(                        XK_4,                                     3)
	TAGKEYS(                        XK_5,                                     4)
	TAGKEYS(                        XK_6,                                     5)
	TAGKEYS(                        XK_7,                                     6)
	TAGKEYS(                        XK_8,                                     7)
	TAGKEYS(                        XK_9,                                     8)
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask			 button          function        argument */
	{ ClkLtSymbol,          0,					 Button1,        cyclelayout,    {.i = +1 } },
	{ ClkLtSymbol,          0,             		 Button3,        setlayout,      {0} },
	{ ClkWinTitle,          0,             		 Button1,        spawn,          {.v = winlist } },
	{ ClkWinTitle,          0,             		 Button2,        killclient,     {0} },
	{ ClkWinTitle,          0,             		 Button3,        focusstack,     {.i = +1 } },
	{ ClkWinTitle,          0,             		 Button4,        focusstack,      {.i = -1 } },
	{ ClkWinTitle,          0,             		 Button5,        focusstack,      {.i = +1 } },
	{ ClkStatusText,        0,					 Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,					 Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,					 Button3,        sigstatusbar,   {.i = 3} },
	{ ClkStatusText,        0,					 Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,					 Button5,        sigstatusbar,   {.i = 5} },
	{ ClkClientWin,         MODKEY,        		 Button1,        movemouse,      {0} }, // move window
	{ ClkClientWin,         MODKEY,        		 Button2,        togglefloating, {0} }, // float window
	{ ClkClientWin,         MODKEY,        		 Button3,        resizemouse,    {0} }, // resize window
	{ ClkClientWin,         MODKEY|ShiftMask,    Button1,        resizemouse,    {0} }, // resize window
	{ ClkTagBar,            0,					 Button1,        view,           {0} }, // view tag
	{ ClkTagBar,            0,             		 Button3,        toggleview,     {0} }, // toggle multiple tags
	{ ClkTagBar,            MODKEY,        		 Button1,        tag,            {0} }, // dont know what it does
	{ ClkTagBar,            MODKEY,        		 Button3,        toggletag,      {0} }, // ||
	{ ClkTagBar,			0,             		 Button4,        shiftviewactive,{.i = -1 } },
	{ ClkTagBar,			0,             		 Button5,        shiftviewactive,{.i = +1 } },
	{ ClkButton,            0,		        	 Button1,        spawn,          {.v = dmenucmd } },
};
