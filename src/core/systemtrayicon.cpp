/*
 * Strawberry Music Player
 * This file was part of Clementine.
 * Copyright 2010, David Sansome <me@davidsansome.com>
 *
 * Strawberry is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Strawberry is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Strawberry.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "config.h"

#include <cmath>

#include <QObject>
#include <QSystemTrayIcon>
#include <QPixmap>
#include <QPainter>
#include <QPoint>
#include <QPolygon>
#include <QRect>
#include <QVector>

#include "systemtrayicon.h"
#include "qtsystemtrayicon.h"
#ifdef Q_OS_MACOS
#  include "macsystemtrayicon.h"
#endif

SystemTrayIcon::SystemTrayIcon(QObject *parent)
  : QObject(parent),
    percentage_(0),
    playing_icon_(":/pictures/tiny-play.png"),
    paused_icon_(":/pictures/tiny-pause.png")
{
}

QPixmap SystemTrayIcon::CreateIcon(const QPixmap &icon, const QPixmap &grey_icon) {

  Q_UNUSED(grey_icon);

  QRect rect(icon.rect());

  // The angle of the line that's used to cover the icon.
  // Centered on rect.topRight()
  double angle = double(100 - song_progress()) / 100.0 * M_PI_2 + M_PI;
  double length = sqrt(pow(rect.width(), 2.0) + pow(rect.height(), 2.0));

  QPolygon mask;
  mask << rect.topRight();
  mask << rect.topRight() + QPoint(length * sin(angle), -length * cos(angle));

  if (song_progress() > 50) mask << rect.bottomLeft();

  mask << rect.topLeft();
  mask << rect.topRight();

  QPixmap ret(icon);
  QPainter p(&ret);

  // Draw the grey bit
  //p.setClipRegion(mask);
  //p.drawPixmap(0, 0, grey_icon);
  //p.setClipping(false);

  // Draw the playing or paused icon in the top-right
  if (!current_state_icon().isNull()) {
    int height = rect.height() / 2;
    QPixmap scaled(current_state_icon().scaledToHeight(height, Qt::SmoothTransformation));

    QRect state_rect(rect.width() - scaled.width(), 0, scaled.width(), scaled.height());
    p.drawPixmap(state_rect, scaled);
  }

  p.end();

  return ret;

}

void SystemTrayIcon::SetProgress(int percentage) {
  percentage_ = percentage;
  UpdateIcon();
}

void SystemTrayIcon::SetPaused() {
  current_state_icon_ = paused_icon_;
  UpdateIcon();
}

void SystemTrayIcon::SetPlaying(bool enable_play_pause) {

  Q_UNUSED(enable_play_pause);

  current_state_icon_ = playing_icon_;
  UpdateIcon();

}

void SystemTrayIcon::SetStopped() {
  current_state_icon_ = QPixmap();
  UpdateIcon();
}

SystemTrayIcon *SystemTrayIcon::CreateSystemTrayIcon(QObject *parent) {
#ifdef Q_OS_MACOS
  return new MacSystemTrayIcon(parent);
#else
  if (QSystemTrayIcon::isSystemTrayAvailable()) return new QtSystemTrayIcon(parent);
  else return nullptr;
#endif
}
