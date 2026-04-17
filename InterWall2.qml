import QtQuick
import QtQuick.Window
import QtQuick.Controls


Window {
    id: main
    // Constants: 
    readonly property real  particles_speed: 0.6
    readonly property int   particles_count: 100
    readonly property int   particle_size: 2
    readonly property int   particles_mouse_distance_px: 200
    readonly property int   particles_respawn_delay: 30  // wait 30 frames before respawn
    
    property var resolution: {"w":Screen.width, "h":Screen.height}
    
    // Window Settings:
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen
    visible: true
    title: "Interactive Wallpaper Layer"
    color: "transparent"
    flags: Qt.FramelessWindowHint

   Action {
        id: quitAction
        text: "Quit"
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }
    
    // Draw the particles into the window on startup
    Component.onCompleted: {
        for (var i = 0; i < particles_count; i++) {
            canvas.particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                dir: Math.random() * Math.PI * 2,
                respawn_delay: 0
            })
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: (mouse) => {
            canvas.mouseX = mouse.x
            canvas.mouseY = mouse.y
        }
    }
    
    // Trigger re-rendering of the particles - movement
    Timer {
        interval: 16   // ~60 FPS
        running: true
        repeat: true
        onTriggered: canvas.requestPaint()
    }
     
    // Canvas to be filled with particles
    // renders or repaints particle movement
    Canvas {
        id: canvas
        anchors.fill: parent

        property var particles: []
        property real mouseX: 0
        property real mouseY: 0

        onPaint: {
            var ctx = getContext("2d")

            // clear frame (transparent)
            ctx.clearRect(0, 0, width, height)

            ctx.fillStyle = "white"

            for (var i = 0; i < particles.length; i++) {
                var p = particles[i]
                
                if (p.respawn_delay)
                {
                    if (! --p.respawn_delay)
                    {
                        /* To save battery, we implement this rather "lazy"
                         * we just use the old particle and remap it to the other site of the display*/
                        p.x = p.x > resolution.w ? p.x - resolution.w : (p.x < resolution.w ? resolution.w - p.x : p.x),
                        p.y = p.y > resolution.h ? p.y - resolution.h : (p.y < resolution.h ? resolution.h - p.y : p.y),
                        //p.direction = particle_ptr->direction,
                        p.respawn_delay = 0
                    }
                    else {continue}
                }

                // update position
                p.x += Math.cos(p.dir) * particles_speed
                p.y += Math.sin(p.dir) * particles_speed
                p.dir += -0.1 + Math.random() * 0.2
                p.respawn_delay = (
                    p.x > resolution.w || p.y > resolution.h || p.x < 0 || p.y < 0
                    ? particles_respawn_delay : 0
                )

                ctx.fillRect(p.x, p.y, particle_size, particle_size)
                
                // Draw a line to the mouse if in reach
                if (! ( Math.abs(p.x - mouseX) <= particles_mouse_distance_px 
                    && Math.abs(p.y - mouseY) <= particles_mouse_distance_px) ) {continue}
                ctx.beginPath()
                ctx.strokeStyle = "red"
                ctx.lineWidth = 1
                ctx.moveTo(p.x, p.y)
                ctx.lineTo(mouseX, mouseY)
                ctx.stroke() // Essential: without this, the line is not drawn
            }
        }
    }
}

