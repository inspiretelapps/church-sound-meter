/**
 *  OSM
 *  Copyright (C) 2019  Pavel Smokotnin

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
#include "palette.h"
using namespace Chart;

Palette::Palette(QObject *parent):
    QObject(parent),
    m_lineColor(), m_textColor(), m_backgroundColor(),
    m_darkMode(true), m_lineWidth(1.8), m_highlightedLineWidth(3.5)
{
    initColors();
}
void Palette::initColors() noexcept
{
    if (m_darkMode) {
        // Deep rich dark mode with subtle blue tint — modern audio tool aesthetic
        m_backgroundColor   = QColor("#0D0D12");      // near-black with subtle blue
        m_lineColor         = QColor(255, 255, 255, 25);  // faint grid
        m_cursorLineColor   = QColor("#8088A0");      // muted blue-grey
        m_centerLineColor   = QColor(255, 255, 255, 120); // semi-transparent white
        m_textColor         = QColor("#D0D4E0");      // soft white
    } else {
        m_backgroundColor   = QColor("#F5F5F7");      // very light warm grey
        m_lineColor         = QColor(0, 0, 0, 20);     // subtle grid
        m_cursorLineColor   = QColor("#9098A8");
        m_centerLineColor   = QColor(0, 0, 0, 100);
        m_textColor         = QColor(0, 0, 0, 230);
    }
    m_cursorLineColor.setAlpha(128);
}
const bool &Palette::darkMode() const noexcept
{
    return m_darkMode;
}
void Palette::setDarkMode(bool darkMode) noexcept
{
    if (darkMode != m_darkMode) {
        m_darkMode = darkMode;
        initColors();
        emit changed();
    }
}

const QColor &Palette::lineColor() const noexcept
{
    return m_lineColor;
}

const QColor &Palette::centerLineColor() const noexcept
{
    return m_centerLineColor;
}

const QColor &Palette::textColor() const noexcept
{
    return m_textColor;
}

const QColor &Palette::backgroundColor() const noexcept
{
    return m_backgroundColor;
}

const QColor &Palette::cursorLineColor() const noexcept
{
    return m_cursorLineColor;
}

const float &Palette::lineWidth(const bool &highlighted) const noexcept
{
    return highlighted ? m_highlightedLineWidth : m_lineWidth;
}
