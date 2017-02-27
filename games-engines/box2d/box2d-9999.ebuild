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
IUSE="-static -doc"

DEPEND=""
RDEPEND="${DEPEND}"

CXXFLAGS="${CXXFLAGS} -std=c++11"

S="${WORKDIR}/${PN}-${PV}/Box2D"

src_configure()
{
	local mycmakeargs=(
                $(cmake-utils_use_with static BOX2D_BUILD_STATIC)
		$(cmake-utils_use_with doc BOX2D_INSTALL_DOC)
		-DBOX2D_BUILD_SHARED=ON
		-DBOX2D_BUILD_EXAMPLES=OFF
		-DCMAKE_BUILD_TYPE=Release
        )
    cmake-utils_src_configure
}
