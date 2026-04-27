workspace.windowAdded.connect(function(window) {
    // Match your Qt window
    if (window.caption === "particle-wallpaper" ||
        window.resourceClass === "particle-wallpaper") {
        
        // Make it click-through
        window.input = false;
    
        // Optional: force it to behave like wallpaper
        window.keepBelow = true;
        window.skipTaskbar = true;
        window.skipSwitcher = true;
        window.skipPager = true;
        //window.onAllDesktops = true;
        window.fullScreen = true;
        
        // to disable win+d keys
        window.desktopWindow = true;
        window.minimized = false;
    }
});
