// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtWayland.Compositor
import QtWayland.Compositor.IviApplication

WaylandCompositor {
    id: waylandCompositor
    property bool scalableDemo: false
    property string appsRoot: ""
    property ListModel shellSurfaces: ListModel {}
    property alias waylandOutput: output

    IviApplication {

        onIviSurfaceCreated: function(iviSurface) {
            if (waylandCompositor.scalableDemo) iviSurface.sendConfigure(Qt.size(output.window.width, output.window.height))
            waylandCompositor.shellSurfaces.append({shellSurface: iviSurface});
        }
    }

    extensions: [
        TextInputManager {},
        QtTextInputMethodManager {}
    ]
    WaylandOutput {
        id: output


        function handleShellSurface(shellSurface) {
            waylandCompositor.shellSurfaces.append({shellSurface: shellSurface});
        }

        sizeFollowsWindow: false
    }
}
