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
                dir: Math.random() * Math.PI * 2
            })
        }
    }
    
    MouseArea {
        anchors.fill: parent
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

                // update position
                p.x += Math.cos(p.dir) * particles_speed
                p.y += Math.sin(p.dir) * particles_speed
                p.dir += -0.1 + Math.random() * 0.2

                ctx.fillRect(p.x, p.y, particle_size, particle_size)
                
                // Draw a line to the mouse if in reach#
                if ()
                ctx.beginPath()
                ctx.strokeStyle = "red"
                ctx.lineWidth = 2
                ctx.moveTo(50, 50)
                ctx.lineTo(150, 150)
                ctx.stroke() // Essential: without this, the line is not drawn
            }
        }
    }

}

