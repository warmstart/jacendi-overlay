# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games cmake-utils git-2 eutils

DESCRIPTION="Enhanced port of the official DOOM source code"
HOMEPAGE="http://zdoom.org"
EGIT_REPO_URI="https://github.com/rheit/zdoom.git"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cpu_flags_x86_mmx +gtk3 +soundfont"

DEPEND="
		cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )
		gtk3? ( x11-libs/gtk+:3 )
		app-arch/bzip2
		sys-libs/zlib
		x11-libs/libXcursor
		media-libs/libsdl2
		media-libs/openal
		media-libs/flac
		virtual/jpeg
		media-sound/fluidsynth
		soundfont? ( media-sound/fluid-soundfont )"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -ie "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" src/posix/i_system.h || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no cpu_flags_x86_mmx ASM)
		$(cmake-utils_use_no gtk3 GTK)
		
		# Disable FMOD, use OpenAL instead
		-DNO_FMOD=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin "${CMAKE_BUILD_DIR}/${PN}" || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/doom-data"
	doins "${CMAKE_BUILD_DIR}/${PN}.pk3" || die "doins failed"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo
	elog "Copy or link WAD files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)"
	elog "or add path to it in your \$HOME/.config/zdoom/zdoom.ini"
	einfo
}
