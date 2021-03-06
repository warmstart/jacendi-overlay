# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games cmake-utils git-2 eutils

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code"
HOMEPAGE="http://www.osnanet.de/c.oelckers/gzdoom/index.html"
EGIT_REPO_URI="https://github.com/coelckers/gzdoom.git"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_mmx +gtk3 +fluidsynth +soundfont"

DEPEND="
		soundfont? (
				fluidsynth? ( media-sound/fluidsynth )
				media-sound/fluid-soundfont
		)

		gtk3? ( x11-libs/gtk+:3 )
		media-libs/flac
		media-libs/openal
		virtual/glu
		virtual/jpeg
		media-libs/libsdl2[opengl]

		cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
		$(cmake-utils_use_no gtk3 GTK)
		$(cmake-utils_use_use fluidsynth FLUIDSYNTH)
	)

	cmake-utils_src_configure
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die

	insinto "${GAMES_DATADIR}/doom"
	doins ${PN}.pk3

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "To play, simply run:"
	elog "   gzdoom"
	elog "See /usr/share/doc/${P}/zdoom.txt.* for more info"
}
