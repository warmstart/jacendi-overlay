# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games eutils cmake-utils git-2

DESCRIPTION="ZDoom BSP node builder"
HOMEPAGE="http://zdoom.org/"
EGIT_REPO_URI="https://github.com/rheit/zdbsp.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# Does anyone really care about the docs?
	use doc && ( dohtml *.{html,png} || die )

	# Binary.
	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	prepgamesdirs
}
