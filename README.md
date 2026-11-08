# dotfiles

## Enviroments(dotfiles with Stow):

For each config needed
stow {folder}
Ex: stow nvim

## System configs (/etc)

Packages that target `/` instead of `~`. Copy, don't stow: systemd services
run with ProtectHome=yes and can't follow symlinks into /home.

sudo install -Dm644 logind/etc/systemd/logind.conf.d/lid.conf /etc/systemd/logind.conf.d/lid.conf
sudo systemctl kill -s HUP systemd-logind

- logind: ignore lid switch (faulty lid sensor triggers false suspends)

## Mutiple Monitors

dnf install xrandr

xrandr --output HDMI-1-1 --auto --right-of eDP-1
