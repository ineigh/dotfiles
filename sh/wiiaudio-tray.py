#!/usr/bin/env python3

import os
import signal
import subprocess
import sys
from pathlib import Path

from PySide6.QtCore import QTimer
from PySide6.QtGui import QAction, QIcon
from PySide6.QtWidgets import QApplication, QMenu, QSystemTrayIcon


SCRIPT = Path.home() / "dotfiles" / "sh" / "wiiaudio.sh"


class WiiAudioTray:
    def __init__(self):
        self.app = QApplication.instance()
        self.app.setQuitOnLastWindowClosed(False)

        self.process = None

        self.tray = QSystemTrayIcon()
        self.tray.setIcon(QIcon.fromTheme("network-disconnect-symbolic"))
        self.tray.setToolTip("WiiAudio: stopped")

        self.menu = QMenu()

        self.start_action = QAction("Start monitoring")
        self.start_action.triggered.connect(self.start)
        self.menu.addAction(self.start_action)

        self.stop_action = QAction("Stop monitoring")
        self.stop_action.triggered.connect(self.stop)
        self.stop_action.setEnabled(False)
        self.menu.addAction(self.stop_action)

        self.menu.addSeparator()

        quit_action = QAction("Quit")
        quit_action.triggered.connect(self.quit)
        self.menu.addAction(quit_action)

        self.tray.setContextMenu(self.menu)
        self.tray.show()

        self.timer = QTimer()
        self.timer.timeout.connect(self.check_process)
        self.timer.start(500)

    def start(self):
        if self.process is not None:
            return

        if not SCRIPT.is_file():
            self.notify(
                "Script not found",
                f"Could not find {SCRIPT}",
            )
            return

        if not os.access(SCRIPT, os.X_OK):
            self.notify(
                "Script is not executable",
                f"Run: chmod +x {SCRIPT}",
            )
            return

        try:
            # A login shell loads ~/.profile, making exported
            # environment variables such as UGREEN_NODE available.
            self.process = subprocess.Popen(
                [
                    "bash",
                    "-lc",
                    'exec "$1"',
                    "wiiaudio-tray",
                    str(SCRIPT),
                ],
                start_new_session=True,
            )
        except OSError as error:
            self.notify("Could not start WiiAudio", str(error))
            return

        self.update_state()
        # self.notify("WiiAudio", "Starting audio monitoring...")

    def stop(self):
        if self.process is None:
            return

        try:
            # The script and pw-loopback share this process group.
            os.killpg(self.process.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass

        self.process = None
        self.update_state()
        # self.notify("WiiAudio", "Audio monitoring stopped.")

    def check_process(self):
        if self.process is not None and self.process.poll() is not None:
            code = self.process.returncode
            self.process = None
            self.update_state()

            if code != 0:
                self.notify(
                    "WiiAudio stopped",
                    f"The script exited with status {code}.",
                )
            else:
                self.notify("WiiAudio", "Audio monitoring ended.")

    def update_state(self):
        running = self.process is not None

        self.start_action.setEnabled(not running)
        self.stop_action.setEnabled(running)

        if running:
            self.tray.setIcon(QIcon.fromTheme("network-connect-symbolic"))
            self.tray.setToolTip("WiiAudio: Running")
        else:
            self.tray.setIcon(QIcon.fromTheme("network-disconnect-symbolic"))
            self.tray.setToolTip("WiiAudio: Stopped")

    def notify(self, title, message):
        self.tray.showMessage(
            title,
            message,
            QSystemTrayIcon.MessageIcon.Information,
        )

    def quit(self):
        self.stop()
        self.app.quit()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    controller = WiiAudioTray()
    sys.exit(app.exec())
