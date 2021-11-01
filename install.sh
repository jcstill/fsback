#!/bin/bash
# fsback installer
# Copyright (C) 2021  Jacob Still
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3
# as published by the Free Software Foundation
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

if [ "$EUID" -ne 0 ];then
	>&2 printf "\e[38;2;255;0;0m[!]\e[0m Please run as root\n"
	exit 1
fi
# install the binary:
install -v -g 0 -o 0 -m 0755 fsback /usr/bin/

# install systemd stuff:
install -v -g 0 -o 0 -m 0640 fsback.service /etc/systemd/system/
install -v -g 0 -o 0 -m 0640 fsback.timer /etc/systemd/system/
systemctl daemon-reload

# install stuff in /etc/fsback:
install -v -g 0 -o 0 -m 0755 -d /etc/fsback
install -v -g 0 -o 0 -m 0755 LICENSE /etc/fsback
install -v -g 0 -o 0 -m 0755 fsback.cfg /etc/fsback/
cat > /etc/fsback/fsback.cfg << EOF
# This file is used by fsback.
# see fsback(5) for help
# put directories to backup here:
EOF

# install manpages:
install -v -g 0 -o 0 -m 0755 -d /usr/local/man/man5
install -v -g 0 -o 0 -m 0644 fsback.5 /usr/local/man/man5/
gzip -f /usr/local/man/man5/fsback.5
install -v -g 0 -o 0 -m 0755 -d /usr/local/man/man8
install -v -g 0 -o 0 -m 0644 fsback.8 /usr/local/man/man8/
gzip -f /usr/local/man/man8/fsback.8
mandb -q

printf "Edit /etc/systemd/system/fsback.timer and /etc/fsback/fsback.db then run:\n"
printf " systemctl enable fsback.timer\n"
printf " systemctl restart fsback.timer\n"
