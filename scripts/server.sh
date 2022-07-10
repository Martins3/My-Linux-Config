#!/opt/homebrew/bin/bash
# https://unix.stackexchange.com/questions/336876/simple-shell-script-to-send-socket-message
while true; do
cat ~/My-Linux-Config/im
fcitx-remote -c
fcitx-remote -o
done

exit 0

while read -r cmd; do
  case $cmd in
    d) date ;;
    q) break ;;
    *) echo 'What?'
  esac
done <&"${COPROC[0]}" >&"${COPROC[1]}"

kill "$COPROC_PID"
