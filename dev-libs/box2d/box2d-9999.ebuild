# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION=2.8
inherit cmake-utils eutils git-r3

DESCRIPTION="Box2D is a 2D rigid body simulation library for games"
HOMEPAGE="http://www.box2d.org"
EGIT_REPO_URI="https://github.com/erincatto/Box2D.git"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-static"

DEPEND="media-libs/freeglut
	x11-libs/libXi"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}/Box2D"

src_configure()
{
	local mycmakeargs=(
                $(cmake-utils_useno static BOX2D_BUILD_SHARED)
        )
	
    cmake-utils_src_configure
}
