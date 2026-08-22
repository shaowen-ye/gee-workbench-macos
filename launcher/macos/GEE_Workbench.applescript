on run
  set homeDir to POSIX path of (path to home folder)
  set launcherPath to homeDir & ".local/share/gee-workbench/launcher/macos/start-gee-workbench.sh"
  set launchCommand to quoted form of launcherPath & " >/dev/null 2>&1 &"
  do shell script "/bin/zsh -lc " & quoted form of launchCommand
end run
