# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3

DESCRIPTION="vAVRdisasm is an 8-bit Atmel AVR disassembler"
HOMEPAGE="https://github.com/vsergeev/vavrdisasm"
EGIT_REPO_URI="https://github.com/vsergeev/vavrdisasm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
    emake DESTDIR="${D}" install
}
