# ~/.bashrc.d/01-cdpath.sh
#
# CDPATH — search path for the cd builtin.
# Entries are searched left-to-right; first match wins.
#
# Do NOT export this variable: child scripts that use `cd` with
# relative paths will break (they'll search CDPATH instead of $PWD).
# Setting it without export keeps it to interactive shells only.

case "$(hostname -s)" in
  fawkes)
    CDPATH=::~:/var/tank/philip/Media/Audio:/var/tank/philip/Media/Video:/var/tank/philip/Media:/var/containers/volumes:/etc/containers/systemd
    ;;
  *)
    CDPATH=::~
    ;;
esac
