import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Particles 6.0
import Qt5Compat.GraphicalEffects

Item {
    id: game
    width: 600
    height: 800
    focus: true

    property int cellSize: 50
    property int roundIndex: 0
    property int totalRounds: 10
    property var targetCells: []
    property var foundCells: []
    property int score: 0
    property real baseSpeed: 900
    property real speedMultiplier: 1.0
    property int currentLevel: 1
    property var unlockedLevels: [true, false, false, false, false, false, false, false, false, false] // Levels 1–10
    property real backgroundOpacity: 1.0

    readonly property int cols: Math.floor(width / cellSize)
    readonly property int rows: Math.floor(height / cellSize)

    // Background with Level-specific gradient and particle effects
    Rectangle {
        anchors.fill: parent
        opacity: backgroundOpacity
        gradient: {
            if (currentLevel === 1) return level1Gradient
            else if (currentLevel === 2) return level2Gradient
            else if (currentLevel === 3) return level3Gradient
            else if (currentLevel === 4) return level4Gradient
            else if (currentLevel === 5) return level5Gradient
            else if (currentLevel === 6) return level6Gradient
            else if (currentLevel === 7) return level7Gradient
            else if (currentLevel === 8) return level8Gradient
            else if (currentLevel === 9) return level9Gradient
            else return level10Gradient
        }
        Gradient {
            id: level1Gradient
            GradientStop { position: 0.0; color: "#1e3a8a" } // Deep navy blue
            GradientStop { position: 1.0; color: "#93c5fd" } // Bright sky blue
        }
        Gradient {
            id: level2Gradient
            GradientStop { position: 0.0; color: "#7f1d1d" } // Deep crimson
            GradientStop { position: 1.0; color: "#fca5a5" } // Light coral
        }
        Gradient {
            id: level3Gradient
            GradientStop { position: 0.0; color: "#14532d" } // Dark forest green
            GradientStop { position: 1.0; color: "#a3e635" } // Vibrant lime
        }
        Gradient {
            id: level4Gradient
            GradientStop { position: 0.0; color: "#4c1d95" } // Deep purple
            GradientStop { position: 1.0; color: "#c4b5fd" } // Light lavender
        }
        Gradient {
            id: level5Gradient
            GradientStop { position: 0.0; color: "#7c2d12" } // Deep orange
            GradientStop { position: 1.0; color: "#fdba74" } // Light peach
        }
        Gradient {
            id: level6Gradient
            GradientStop { position: 0.0; color: "#164e63" } // Deep teal
            GradientStop { position: 1.0; color: "#5eead4" } // Light aqua
        }
        Gradient {
            id: level7Gradient
            GradientStop { position: 0.0; color: "#5b21b6" } // Deep violet
            GradientStop { position: 1.0; color: "#c084fc" } // Light purple
        }
        Gradient {
            id: level8Gradient
            GradientStop { position: 0.0; color: "#78350f" } // Deep amber
            GradientStop { position: 1.0; color: "#fcd34d" } // Light yellow
        }
        Gradient {
            id: level9Gradient
            GradientStop { position: 0.0; color: "#1e40af" } // Deep blue
            GradientStop { position: 1.0; color: "#93c5fd" } // Bright sky blue
        }
        Gradient {
            id: level10Gradient
            GradientStop { position: 0.0; color: "#831843" } // Deep magenta
            GradientStop { position: 1.0; color: "#f9a8d4" } // Light pink
        }
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
        ParticleSystem {
            id: backgroundParticles
            running: true
            Component.onCompleted: console.log("Background ParticleSystem initialized for Level " + currentLevel)
            Emitter {
                anchors.fill: parent
                emitRate: 15 + currentLevel * 5 // 20–65 particles
                lifeSpan: 4000
                size: 6 + currentLevel * 0.6 // 6–12 pixels
                sizeVariation: 4
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 45
                    magnitude: 40 + currentLevel * 10 // 50–130
                }
            }
            ImageParticle {
                id: backgroundStarParticle
                source: "qrc:/particleresources/star.png"
                colorVariation: 0.5
                colorTable: {
                    if (currentLevel === 1) return ["#60a5fa", "#3b82f6", "#1d4ed8"] // Blue
                    else if (currentLevel === 2) return ["#f87171", "#ef4444", "#b91c1c"] // Red
                    else if (currentLevel === 3) return ["#86efac", "#22c55e", "#15803d"] // Green
                    else if (currentLevel === 4) return ["#a78bfa", "#8b5cf6", "#6d28d9"] // Purple
                    else if (currentLevel === 5) return ["#fb923c", "#f97316", "#ea580c"] // Orange
                    else if (currentLevel === 6) return ["#5eead4", "#14b8a6", "#0d9488"] // Teal
                    else if (currentLevel === 7) return ["#c084fc", "#a855f7", "#9333ea"] // Violet
                    else if (currentLevel === 8) return ["#fcd34d", "#facc15", "#eab308"] // Yellow
                    else if (currentLevel === 9) return ["#60a5fa", "#3b82f6", "#1d4ed8"] // Blue (reused)
                    else return ["#f9a8d4", "#ec4899", "#db2777"] // Pink
                }
                alpha: 0.2 + currentLevel * 0.05 // 0.25–0.7
                rotation: 360
                rotationVariation: 180
                Component.onCompleted: {
                    if (!source) {
                        console.log("Warning: star.png not found, switching to ItemParticle fallback")
                    }
                }
            }
            ItemParticle {
                id: backgroundStarFallback
                delegate: Rectangle {
                    width: 6 + currentLevel * 0.6
                    height: width
                    radius: width / 2
                    color: {
                        if (currentLevel === 1) return "#60a5fa"
                        else if (currentLevel === 2) return "#f87171"
                        else if (currentLevel === 3) return "#86efac"
                        else if (currentLevel === 4) return "#a78bfa"
                        else if (currentLevel === 5) return "#fb923c"
                        else if (currentLevel === 6) return "#5eead4"
                        else if (currentLevel === 7) return "#c084fc"
                        else if (currentLevel === 8) return "#fcd34d"
                        else if (currentLevel === 9) return "#60a5fa"
                        else return "#f9a8d4"
                    }
                    opacity: 0.2 + currentLevel * 0.05
                }
                enabled: !backgroundStarParticle.source
            }
        }
        Rectangle {
            id: messageBox
            width: 240; height: 90
            color: "#cc4d4d88"
            radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            visible: false
            z: 999
            Glow {
                anchors.fill: parent
                source: messageBox
                radius: 8
                samples: 16
                color: "#ffffff"
                opacity: 0.3
            }
            Text {
                anchors.centerIn: parent
                text: "Time's Up!"
                font.family: "Arial"
                font.pixelSize: 22
                //color: "white"
                //style: Text.Outline
                styleColor: "#000000"
            }
            Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
        }
        Text {
            id: levelText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 15
            text: "Level: " + currentLevel
            font.family: "Arial"
            font.pixelSize: 28
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            z: 999
        }
        Text {
            id: scoreText
            anchors.top: levelText.bottom
            anchors.left: parent.left
            anchors.margins: 15
            text: "Score: " + score
            font.family: "Arial"
            font.pixelSize: 28
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            z: 999
        }
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "#555"
            ctx.lineWidth= 1.5
            for (var i = 0; i <= cols; i++) {
                ctx.moveTo(i * cellSize, 0)
                ctx.lineTo(i * cellSize, height)
            }
            for (var j = 0; j <= rows; j++) {
                ctx.moveTo(0, j * cellSize)
                ctx.lineTo(width, j * cellSize)
            }
            ctx.stroke()
        }
    }

    Player {
        id: player
        cellSize: game.cellSize
        x: (game.width - width) / 2
        y: game.height - height - 8
        enabled: false
        Component.onCompleted: cellEntered.connect(onPlayerCellEntered)
    }

    MouseArea {
        anchors.fill: parent
        drag.target: player
        drag.axis: Drag.XandYAxis
        onPositionChanged: {
            player.notifyCell(Math.floor(player.x / cellSize), Math.floor(player.y / cellSize))
        }
    }

    Item { id: shapeLayer; anchors.fill: parent }

    Rectangle {
        id: checkMark
        visible: false
        width: 100; height: 100
        radius: 50
        anchors.centerIn: parent
        color: "transparent"
        border.color: "#22c55e"
        border.width: 6
        Text {
            anchors.centerIn: parent
            text: "✔"
            font.family: "Arial"
            font.pixelSize: 70
            color: "#22c55e"
            style: Text.Outline
            styleColor: "#ffffff"
        }
        Glow {
            anchors.fill: parent
            source: checkMark
            radius: 10
            samples: 20
            color: "#22c55e"
            opacity: 0.5
        }
        SequentialAnimation {
            running: checkMark.visible
            NumberAnimation { target: checkMark; property: "scale"; from: 0.5; to: 1.0; duration: 400; easing.type: Easing.OutBounce }
            NumberAnimation { target: checkMark; property: "rotation"; to: 360; duration: 400; easing.type: Easing.InOutQuad }
        }
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        id: endGameBox
        width: 420; height: 320
        radius: 20
        color: "#22c55eCC"
        anchors.centerIn: parent
        visible: false
        scale: 0
        z: 1000
        Glow {
            anchors.fill: parent
            source: endGameBox
            radius: 12
            samples: 24
            color: "#ffffff"
            opacity: 0.4
        }
        Text {
            anchors.centerIn: parent
            text: {
                if (currentLevel < 10) {
                    return score > 50 ? "🎉 Level " + currentLevel + " Completed!\nTotal Score: " + score + "\nNext Level Unlocked!" : "❌ Level " + currentLevel + " Not Completed!\nTotal Score: " + score + "\nNeed Score Above 50"
                } else {
                    return "🎉 All Levels Completed!\nTotal Score: " + score
                }
            }
            font.family: "Arial"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Button {
            id: levelTransitionButton
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            text: currentLevel < 10 ? (score > 50 ? "Start Level " + (currentLevel + 1) : "Try Again") : ""
            visible: currentLevel < 10
            background: Rectangle {
                color: "#22c55e"
                radius: 10
                border.color: "#ffffff"
                border.width: 2
            }
            contentItem: Text {
                text: parent.text
                font.family: "Arial"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                backgroundOpacity = 0
                score = 0
                roundIndex = 0
                endGameBox.visible = false
                endGameBox.scale = 0
                if (score > 50 && currentLevel < 10) {
                    currentLevel += 1
                    unlockedLevels[currentLevel - 1] = true
                    console.log("Manual advance to Level " + currentLevel + ", score: " + score)
                } else {
                    console.log("Retrying Level " + currentLevel + ", score was: " + score)
                }
                levelTransitionTimer.start()
            }
        }
        Timer {
            id: levelTransitionTimer
            interval: 500
            repeat: false
            onTriggered: {
                backgroundOpacity = 1
                spawnShape()
                console.log("Transition completed to Level " + currentLevel + ", spawning shapes")
            }
        }
        Behavior on scale { NumberAnimation { duration: 800; easing.type: Easing.OutBounce } }
    }

    Window {
        id: victoryWindow
        width: 400
        height: 400
        visible: false
        color: "transparent"
        flags: Qt.Dialog
        title: "You Won!"
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1e1b4b" } // Deep indigo
                GradientStop { position: 1.0; color: "#6b21a8" } // Vibrant purple
            }
        }
        ParticleSystem {
            id: particleSystem
            running: victoryWindow.visible
            Component.onCompleted: console.log("Victory ParticleSystem initialized")
            Emitter {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                emitRate: 200
                lifeSpan: 3000
                size: 14
                sizeVariation: 7
                velocity: AngleDirection {
                    angle: 0
                    angleVariation: 360
                    magnitude: 300
                }
            }
            ImageParticle {
                id: victoryStarParticle
                source: "qrc:/particleresources/star.png"
                colorVariation: 0.6
                colorTable: ["#ffd700", "#ff4500", "#00ff7f", "#1e90ff", "#ff69b4"] // Gold, OrangeRed, SpringGreen, DodgerBlue, HotPink
                rotation: 360
                rotationVariation: 180
                rotationVelocity: 80
                alpha: 0.8
                Component.onCompleted: {
                    if (!source) {
                        console.log("Warning: star.png not found in victoryWindow, switching to ItemParticle fallback")
                    }
                }
            }
            ItemParticle {
                id: victoryStarFallback
                delegate: Rectangle {
                    width: 14
                    height: 14
                    radius: 7
                    color: "#ffd700"
                    opacity: 0.8
                }
                enabled: !victoryStarParticle.source
            }
            Emitter {
                anchors.centerIn: parent
                width: parent.width / 2
                height: parent.height / 2
                emitRate: 50
                lifeSpan: 2000
                size: 10
                sizeVariation: 5
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 180
                    magnitude: 150
                }
            }
            ImageParticle {
                id: victoryGlowParticle
                source: "qrc:/particleresources/glowdot.png"
                colorVariation: 0.5
                color: "#ffffff"
                alpha: 0.5
                rotation: 0
                Component.onCompleted: {
                    if (!source) {
                        console.log("Warning: glowdot.png not found in victoryWindow, switching to ItemParticle fallback")
                    }
                }
            }
            ItemParticle {
                id: victoryGlowFallback
                delegate: Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: "#ffffff"
                    opacity: 0.5
                }
                enabled: !victoryGlowParticle.source
            }
        }
        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -50 // Offset to avoid overlap with button
            text: "🎉 You Won! 🎉"
            font.family: "Arial"
            font.pixelSize: 52
            color: "white"
            style: Text.Outline
            styleColor: "#ffd700"
            SequentialAnimation {
                running: victoryWindow.visible
                loops: Animation.Infinite
                NumberAnimation { target: parent; property: "scale"; to: 1.4; duration: 600; easing.type: Easing.InOutQuad }
                NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
            }
            Glow {
                anchors.fill: parent
                source: parent
                radius: 10
                samples: 20
                color: "#ffd700"
                opacity: 0.6
            }
        }
        Button {
            id: resetButton
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 50 // Offset to avoid overlap with text
            width: 200
            height: 60
            text: "Start Again?"
            background: Rectangle {
                color: "#22c55e"
                radius: 10
                border.color: "#ffffff"
                border.width: 2
            }
            contentItem: Text {
                text: parent.text
                font.family: "Arial"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                victoryWindow.visible = false
                currentLevel = 1
                unlockedLevels = [true, false, false, false, false, false, false, false, false, false]
                score = 0
                roundIndex = 0
                backgroundOpacity = 0
                resetTimer.start()
                console.log("Game reset to Level 1 from victory window")
            }
        }
        Timer {
            id: resetTimer
            interval: 500
            repeat: false
            onTriggered: {
                backgroundOpacity = 1
                spawnShape()
                console.log("Game reset to Level 1, spawning shapes")
            }
        }
    }

    Connections {
        target: AI
        function onFlashCell(x, y, intensity) {
            console.log("AI flashCell signal received: x=" + x + ", y=" + y + ", intensity=" + intensity)
            for (let i = 0; i < shapeLayer.children.length; i++) {
                let c = shapeLayer.children[i]
                if (c.col === x && c.row === y) {
                    if (intensity === 1) c.color = "#FFFF66"
                    else if (intensity === 2) c.color = "#FF9900"
                    else c.color = "#FF3333"
                    c.scale = 1.3
                    c.opacity = 1
                    break
                }
            }
        }
        function onHideHint(x, y) {
            console.log("AI hideHint signal received: x=" + x + ", y=" + y)
            for (let i = 0; i < shapeLayer.children.length; i++) {
                let c = shapeLayer.children[i]
                if (c.col === x && c.row === y) {
                    c.color = "#ef4444"
                    c.scale = 1
                    c.opacity = c.fadeOut ? 0 : 1
                    break
                }
            }
        }
    }

    Timer {
        id: fadeOutTimer
        interval: 1000
        repeat: false
        onTriggered: {
            for (let i = 0; i < shapeLayer.children.length; i++) {
                shapeLayer.children[i].fadeOut = true
            }
            player.enabled = true
            responseTimer.restart()
            console.log("FadeOutTimer triggered, enabling player for Level " + currentLevel + ", score: " + score)
        }
    }

    Timer {
        id: responseTimer
        interval: 3000
        repeat: false
        onTriggered: {
            if (foundCells.length === targetCells.length) {
                checkMark.visible = true
                score += 10
                console.log("Round success, score incremented to: " + score)
            } else {
                messageBox.visible = true
                messageBox.scale = 1.1
                console.log("Round failed, showing Time's Up!, score: " + score)
            }
            player.enabled = false
            responseHideTimer.start()
        }
    }

    Timer {
        id: responseHideTimer
        interval: 1000
        repeat: false
        onTriggered: {
            messageBox.visible = false
            messageBox.scale = 1.0
            checkMark.visible = false
            roundIndex++
            console.log("ResponseHideTimer triggered, roundIndex: " + roundIndex + ", currentLevel: " + currentLevel + ", score: " + score)
            if (roundIndex < totalRounds) {
                spawnShape()
                console.log("Round " + roundIndex + " in Level " + currentLevel + ", spawning shapes")
            } else {
                if (currentLevel < 10 && score > 50) {
                    // Auto-advance to next Level
                    currentLevel += 1
                    unlockedLevels[currentLevel - 1] = true
                    backgroundOpacity = 0
                    score = 0
                    roundIndex = 0
                    levelTransitionTimer.start()
                    console.log("Auto-advancing to Level " + currentLevel + ", score: " + score)
                } else if (currentLevel === 10 && score > 50) {
                    endGameBox.visible = false
                    endGameBox.scale = 0
                    victoryWindow.visible = true
                    console.log("Level 10 completed, showing victory window, score: " + score)
                } else {
                    endGameBox.visible = true
                    endGameBox.scale = 1
                    console.log("Level " + currentLevel + " ended, score: " + score + ", showing endGameBox")
                }
            }
        }
    }

    function clearShape() {
        for (let i = shapeLayer.children.length - 1; i >= 0; i--) {
            shapeLayer.children[i].destroy()
        }
        targetCells = []
        foundCells = []
    }

    function generatePattern(numCells) {
        // Generate a connected pattern with numCells (5–10) cells
        let cells = []
        let grid = []
        let maxSize = 5 // Max width/height of pattern bounding box
        for (let i = 0; i < maxSize; i++) {
            grid[i] = []
            for (let j = 0; j < maxSize; j++) {
                grid[i][j] = false
            }
        }

        // Start with a random cell
        let startX = Math.floor(Math.random() * maxSize)
        let startY = Math.floor(Math.random() * maxSize)
        grid[startX][startY] = true
        cells.push({x: startX, y: startY})

        // Directions for adjacent cells (up, right, down, left)
        let directions = [
            {dx: 0, dy: -1}, {dx: 1, dy: 0}, {dx: 0, dy: 1}, {dx: -1, dy: 0}
        ]

        // Random walk to add connected cells
        while (cells.length < numCells) {
            let lastCell = cells[Math.floor(Math.random() * cells.length)]
            let dir = directions[Math.floor(Math.random() * directions.length)]
            let newX = lastCell.x + dir.dx
            let newY = lastCell.y + dir.dy

            if (newX >= 0 && newX < maxSize && newY >= 0 && newY < maxSize && !grid[newX][newY]) {
                grid[newX][newY] = true
                cells.push({x: newX, y: newY})
            }
        }

        // Normalize coordinates to start from (0,0)
        let minX = Math.min(...cells.map(c => c.x))
        let minY = Math.min(...cells.map(c => c.y))
        cells = cells.map(c => ({x: c.x - minX, y: c.y - minY}))
        return cells
    }

    function spawnShape() {
        player.enabled = false
        checkMark.visible = false
        messageBox.visible = false
        clearShape()
        // Random number of cells: 5–10
        var numCells = Math.floor(Math.random() * 6) + 5
        var shape = generatePattern(numCells)
        var maxX = Math.max(...shape.map(c => c.x))
        var maxY = Math.max(...shape.map(c => c.y))
        var shapeW = maxX + 1
        var shapeH = maxY + 1
        var maxCol = Math.max(0, cols - shapeW)
        var maxRow = Math.max(0, rows - 3 - shapeH)
        var finalCol = Math.floor(Math.random() * (maxCol + 1))
        var finalRow = Math.floor(Math.random() * (maxRow + 1))
        var finalOriginX = finalCol * cellSize
        var finalOriginY = finalRow * cellSize

        for (let i = 0; i < shape.length; i++) {
            let dx = shape[i].x
            let dy = shape[i].y
            let cell = Qt.createQmlObject(
                'import QtQuick 6.6; import Qt5Compat.GraphicalEffects; Rectangle { width:' + cellSize + '; height:' + cellSize + '; radius:6; color:"#ef4444"; border.color:"#ffffff"; border.width:2; property int col:' + (finalCol + dx) + '; property int row:' + (finalRow + dy) + '; property bool fadeOut:false; scale:0; Behavior on y { NumberAnimation { duration:' + (baseSpeed * speedMultiplier) + '; easing.type:Easing.InOutQuad } } Behavior on opacity { NumberAnimation { duration:500 } } Behavior on color { ColorAnimation { duration:400 } } Behavior on scale { NumberAnimation { duration:400; easing.type:Easing.OutBack } } onFadeOutChanged: { if(fadeOut){opacity=0} } Component.onCompleted: { scale=1 } Glow { anchors.fill: parent; source: parent; radius:8; samples:16; color: parent.color; opacity:0.4 } MouseArea { anchors.fill: parent; onClicked: { if(parent.color!="#22c55e"){ parent.color="#22c55e"; parent.opacity=1; parent.scale=1.3; game.onPlayerCellEntered({x:col,y:row}) } } } }',
                shapeLayer, 'cell' + i
            )
            cell.x = finalOriginX + dx * cellSize
            cell.y = finalOriginY + dy * cellSize
            targetCells.push({x: finalCol + dx, y: finalRow + dy, found: false, weight: Math.ceil(Math.random() * 3)})
        }

        console.log("Spawned " + shape.length + " cells for Level " + currentLevel)
        if (shapeLayer.children.length === 0) {
            console.log("No shapes spawned, retrying...")
            spawnShape()
        }
        fadeOutTimer.start()
        AI.startAdvancedHint(targetCells, Math.min(3, Math.floor(score / 20) + 1))
        console.log("Called AI.startAdvancedHint with " + targetCells.length + " cells, level: " + Math.min(3, Math.floor(score / 20) + 1))
    }

    function onPlayerCellEntered(cell) {
        for (var i = 0; i < targetCells.length; i++) {
            var c = targetCells[i]
            if (c.found) continue
            if (c.x == cell.x && c.y == cell.y) {
                c.found = true
                foundCells.push(c)
                // Light up the cell in shapeLayer
                for (let j = 0; j < shapeLayer.children.length; j++) {
                    let shapeCell = shapeLayer.children[j]
                    if (shapeCell.col === c.x && shapeCell.row === c.y) {
                        shapeCell.color = "#22c55e"
                        shapeCell.opacity = 1
                        shapeCell.scale = 1.3
                        console.log("Player correctly touched cell at (" + c.x + ", " + c.y + "), lighting up")
                        break
                    }
                }
                console.log("Player hit cell at (" + c.x + ", " + c.y + "), foundCells: " + foundCells.length)
                break
            }
        }
    }

    Component.onCompleted: {
        spawnShape()
        console.log("Game started, initial shapes spawned for Level 1")
    }
}
