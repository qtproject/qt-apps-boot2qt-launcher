/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import AutomationHelper 1.0

Item {
    property var visibleItem
    property var demoHeader
    property var launcherHeader
    property var visibleItemName: visibleItem ? visibleItem.objectName : 0
    property bool demoModeSeleted: globalSettings.demoModeSelected
    property bool demoIsRunning: false

    property int demoInitialStartTime: 2000         // How fast demo starts after turning the demo on
    property int demoIdleStartTime: 2 * 60 * 1000   // How fast demo starts after idle
    property int demoStepDuration: 2000
    property int applicationWaitDuration: 1000
    property int verticalFlickVelocity: 1000
    property int horizontalFlickVelocity: 1000

    onDemoModeSeletedChanged: {
        if (demoModeSeleted) {
            demoStartCounter.interval = demoInitialStartTime
            demoStartCounter.start()
        } else {
            demoStartCounter.stop()
            stopDemos()
        }
    }

    /*
      Start the demo sequence. First demo to start depends on the current screen.
    */
    function startDemos() {
        console.log("Start automatic demo mode")
        if (visibleItemName === "settingsView") {
            settingsDemoAnimation.start()
        } else if ((visibleItemName === "launchScreen") || (visibleItemName === "detailView")) {
            switchToSettingScreenAnimation.start()
        } else {
            exitFromRunningDemoAnimation.start()
        }

        demoIsRunning = true
    }

    /*
      Stop all currently running demos
    */
    function stopDemos() {
        console.log("Stop automatic demo mode")
        switchToSettingScreenAnimation.stop()
        settingsDemoAnimation.stop()
        gridViewDemoAnimation.stop()
        graphicsEffectsDemoAnimation.stop()
        qtChartsDemoAnimation.stop()
        switchToDetailViewAnimation.stop()
        detailViewDemoAnimation.stop()
        eBikeViewDemoAnimation.stop()
        demoIsRunning = false

        // Restart demo after idle time
        if (demoModeSeleted) {
            demoStartCounter.interval = demoIdleStartTime
            demoStartCounter.restart()
        }
    }

    Timer {
        id: demoStartCounter
        repeat: false
        onTriggered: startDemos()
    }

    /*
      Cet index of with \a title from the \a applicationList
    */
    function applicationIndex(applicationList, title) {
        var i
        var applicationListModel = applicationList.model

        // count and get() do not work on QAbstractItemModel, rowCount and query must be used
        for (i=0; i<applicationListModel.rowCount(); i++) {
            if (applicationListModel.query(i, "name") === title) {
                return i
            }
        }
        return -1
    }

    /*
      Click application with \a title from the launcher with \a launcherName

      Returns \c true if application launcher was clicked
    */
    function clickApplicationLauncher(launcherName, title) {
        var applicationList = automationHelper.findChildObject(visibleItem, launcherName)
        var index = applicationIndex(applicationList, title)

        if (index !== -1) {
            applicationList.currentIndex = index;
            automationHelper.click(applicationList.currentItem)
            return true
        }
        return false
    }

    /*
      Flick flickable with objectName \a objName with \a amountHorizontal and \a amountVertical
    */
    function flickUpDown(objName, amountHorizontal, amountVertical) {
        var gridView = automationHelper.findChildObject(visibleItem, objName)
        if (gridView)
            gridView.flick(amountHorizontal, amountVertical)
        else
            console.log("no child " + objName)
    }

    AutomationHelper {
        id: automationHelper
    }

    // Exit from already running demo
    SequentialAnimation {
        id: exitFromRunningDemoAnimation
        ScriptAction { script: console.log("Exit from running demo") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(demoHeader, "applicationCloseButton") }
        PauseAnimation { duration: applicationWaitDuration }

        // Start next demo
        ScriptAction { script: switchToSettingScreenAnimation.start() }
    }

    // Switch to settings screen
    SequentialAnimation {
        id: switchToSettingScreenAnimation
        ScriptAction { script: console.log("Switch to settings screen") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(launcherHeader, "settingsMenuIcon") }
        PauseAnimation { duration: applicationWaitDuration }

        // Start next demo
        ScriptAction { script: settingsDemoAnimation.start() }
    }

    // Settings screen
    SequentialAnimation {
        id: settingsDemoAnimation

        function clickSettingsItem(title) {
            var i
            var settingsList = automationHelper.findChildObject(visibleItem, "settingsList")
            var settingsModel = settingsList.model

            // count + get() can be used on ListModel
            for (i=0; i<settingsModel.count; i++) {
                if (settingsModel.get(i).title === title) {
                    settingsList.currentIndex = i
                    automationHelper.click(settingsList.currentItem)
                }
            }
        }

        ScriptAction { script: console.log("Settings demo") }
        PauseAnimation { duration: applicationWaitDuration }

        // Make sure the grid layout is on
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "gridLayoutButton") }
        PauseAnimation { duration: demoStepDuration }

        // Show some settings pages
        ScriptAction { script: settingsDemoAnimation.clickSettingsItem("Network") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: settingsDemoAnimation.clickSettingsItem("Date & Time") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: settingsDemoAnimation.clickSettingsItem("About Qt") }
        PauseAnimation { duration: demoStepDuration }

        // Go back to launcher screen and start next demo
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "settingsBackButton") }
        ScriptAction { script: gridViewDemoAnimation.start() }
    }

    // Grid view demo
    SequentialAnimation {
        id: gridViewDemoAnimation

        // Flick the grid up and down
        ScriptAction { script: console.log("Grid view demo") }
        PauseAnimation { duration: applicationWaitDuration }
        ScriptAction { script: flickUpDown("launcherGridView", 0, -verticalFlickVelocity) }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: flickUpDown("launcherGridView", 0, verticalFlickVelocity) }

        // Start next demo
        ScriptAction { script: graphicsEffectsDemoAnimation.start() }
    }

    // Graphics effects demo
    SequentialAnimation {
        id: graphicsEffectsDemoAnimation

        function clickGraphicsEffectItem(title) {
            var i
            var effectList = automationHelper.findChildObject(visibleItem, "graphicsEffectsList")
            var effectListModel = effectList.model

            // count + get() can be used on ListModel
            for (i=0; i<effectListModel.count; i++) {
                if (effectListModel.get(i).name === title) {
                    effectList.currentIndex = i
                    automationHelper.click(effectList.currentItem)
                }
            }
        }

        // Start the demo application
        ScriptAction { script: console.log("Graphics effects demo") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction {
            script: {
                // If the application does not exist, move on to next demo
                if (!clickApplicationLauncher("launcherGridView", "Graphical Effects")) {
                    qtChartsDemoAnimation.start()
                    graphicsEffectsDemoAnimation.stop()
                }
            }
        }
        PauseAnimation { duration: applicationWaitDuration }

        // Show few graphics effects
        ScriptAction { script: graphicsEffectsDemoAnimation.clickGraphicsEffectItem("Colorize") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: graphicsEffectsDemoAnimation.clickGraphicsEffectItem("Gaussian Blur") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: graphicsEffectsDemoAnimation.clickGraphicsEffectItem("Wave (custom)") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(demoHeader, "applicationCloseButton") }

        // Start next demo
        ScriptAction { script: qtChartsDemoAnimation.start() }
    }

    // Qt charts demo
    SequentialAnimation {
        id: qtChartsDemoAnimation
        property var chartsList

        // Start the demo application and get the chart list
        ScriptAction { script: console.log("Qt charts demo") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: flickUpDown("launcherGridView", 0, -1.5 * verticalFlickVelocity) }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction {
            script: {
                // If the application does not exist, move on to next demo
                if (!clickApplicationLauncher("launcherGridView", "Qt Charts - Gallery")) {
                    switchToDetailViewAnimation.start()
                    qtChartsDemoAnimation.stop()
                }
            }
        }
        PauseAnimation { duration: applicationWaitDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList = automationHelper.findChildObject(visibleItem, "chartsListView") }

        // Flick through some of the charts
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 1 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 2 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 3 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 4 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 5 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 6 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 7 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 8 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: qtChartsDemoAnimation.chartsList.currentIndex = 9 }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(demoHeader, "applicationCloseButton") }

        // Start next demo
        ScriptAction { script: switchToDetailViewAnimation.start() }
    }

    // Switch to detail view demo
    SequentialAnimation {
        id: switchToDetailViewAnimation
        ScriptAction { script: console.log("Switch to detail view demo") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(launcherHeader, "settingsMenuIcon") }
        PauseAnimation { duration: applicationWaitDuration }
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "detailLayoutButton") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "settingsBackButton") }

        // Start next demo
        ScriptAction { script: detailViewDemoAnimation.start() }
    }

    // Detail view demo
    SequentialAnimation {
        id: detailViewDemoAnimation

        // Flick the list left and right
        ScriptAction { script: console.log("Detail view demo") }
        PauseAnimation { duration: applicationWaitDuration }
        ScriptAction { script: flickUpDown("detailListView", -horizontalFlickVelocity, 0) }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: flickUpDown("detailListView", horizontalFlickVelocity, 0) }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: clickApplicationLauncher("detailListView", "Media Player") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: clickApplicationLauncher("detailListView", "Quick Controls 2") }

        // Start next demo
        ScriptAction { script: eBikeViewDemoAnimation.start() }
    }

    // E-Bike view demo
    SequentialAnimation {
        id: eBikeViewDemoAnimation

        // Start the demo application
        ScriptAction { script: console.log("E-Bike demo") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction {
            script: {
                // If the application does not exist, move on to next demo
                if (!clickApplicationLauncher("detailListView", "E-Bike")) {
                    startDemos()
                    eBikeViewDemoAnimation.stop()
                }
            }
        }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "detailStartButton") }
        PauseAnimation { duration: applicationWaitDuration }

        // Turn on lights
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "ebikeLightsButton") }
        PauseAnimation { duration: demoStepDuration }

        // Go to navigation view and come back
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "ebikeNaviButton") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "ebikeSpeedView") }
        PauseAnimation { duration: demoStepDuration }

        // Go to stats view and come back
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "ebikeStatsButton") }
        PauseAnimation { duration: demoStepDuration }
        ScriptAction { script: automationHelper.clickChildObject(visibleItem, "ebikeSpeedView") }
        PauseAnimation { duration: 5*demoStepDuration }

        // Go back to main view
        ScriptAction { script: automationHelper.clickChildObject(demoHeader, "applicationCloseButton") }

        // Start demos again
        PauseAnimation { duration: 2 * demoStepDuration }
        ScriptAction { script: startDemos() }
    }
}
