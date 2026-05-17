export KWIN_PERSISTENT_VBO=1 #default?
export KWIN_USE_BUFFER_AGE=1 #default
export KWIN_EXPLICIT_SYNC=0 #Xorg takes care of it
export KWIN_X11_NO_SYNC_TO_VBLANK=1 #Xorg takes care of it
export KWIN_USE_INTEL_SWAP_EVENT=1 #not default, should be relevant only on glx, but we are going to use EGL

export KWIN_X11_REFRESH_RATE=165000 # the refresh rate of the fastest monitor * 1000, in this case 144 Hz. In most cases, this line is sufficient. Test it before adding the third one.
export KWIN_X11_NO_SYNC_TO_VBLANK=1
#export KWIN_X11_FORCE_SOFTWARE_VSYNC=1 #try also without this
