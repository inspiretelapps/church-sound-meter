/**
 *  OSM
 *  Copyright (C) 2023  Pavel Smokotnin

 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "qrc:/"

Item {
    id: control
    property var dataModel
    property bool chartable
    property bool highlight
    property string propertiesQml
    height: 50
    width: parent.width

    // Glass background for source items
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 6
        color: {
            if (highlight)
                return applicationAppearance.darkMode
                    ? Qt.rgba(0.40, 0.60, 1.0, 0.15)
                    : Qt.rgba(0.30, 0.50, 0.90, 0.10)
            return applicationAppearance.darkMode
                ? Qt.rgba(0.18, 0.18, 0.22, 0.45)
                : Qt.rgba(0.96, 0.96, 0.98, 0.80)
        }
        border.color: {
            if (highlight)
                return Qt.rgba(0.40, 0.60, 1.0, 0.30)
            return applicationAppearance.darkMode
                ? Qt.rgba(1.0, 1.0, 1.0, 0.06)
                : Qt.rgba(0, 0, 0, 0.05)
        }
        border.width: 1
        z: -1
    }
}
