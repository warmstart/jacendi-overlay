# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games eutils

DESCRIPTION="Harmony is a computer game made by Thomas van der Velden."
HOMEPAGE="http://rabotik.nl/harmony.htm"
SRC_URI="https://github.com/Jacendi/harmony-game/archive/v1.1.tar.gz"

KEYWORDS="-* amd64 x86"
IUSE=""
SLOT="0"

RDEPEND="|| ( games-fps/zdoom games-fps/gzdoom )"

S="${WORKDIR}/harmony-game-1.1"

src_install()
{
    insinto "${GAMES_DATADIR}/doom"
    doins harm1.wad || die

    prepgamesdirs
}
