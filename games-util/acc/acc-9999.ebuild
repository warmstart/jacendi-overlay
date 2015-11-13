# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games git-2 eutils

DESCRIPTION="Action Code Script compiler for HeXen/ZDoom"
HOMEPAGE="http://zdoom.org/"
EGIT_REPO_URI="https://github.com/rheit/acc.git"

LICENSE="DOOMLIC BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# Add the game data path to the include list.
	sed -ie "s:/usr/local/share/:${GAMES_DATADIR}/:" acc.c || die
}

src_install() {
	# Binary.
	dogamesbin ${PN} || die

	# Install the bundled *.acs files.
	insinto "${GAMES_DATADIR}/${PN}"
	doins *.acs || die

	prepgamesdirs
}
