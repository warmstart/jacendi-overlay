# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )


inherit git-r3 cmake-utils python-single-r1

EGIT_REPO_URI="https://github.com/jaagr/polybar"

DESCRIPTION="A fast and easy-to-use tool for creating status bars."
HOMEPAGE="https://github.com/jaagr/polybar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="+alsa i3 mpd curl network"

RDEPEND="
        x11-libs/libxcb[xkb]
        x11-libs/cairo[xcb]
        x11-proto/xcb-proto
        x11-libs/xcb-util-wm
        x11-libs/xcb-util-image

        alsa? ( media-libs/alsa-lib )
        i3? ( dev-libs/jsoncpp || ( x11-wm/i3 x11-wm/i3-gaps ) )
        mpd? ( media-libs/libmpdclient )
        curl? ( net-misc/curl )
        network? ( net-wireless/wireless-tools )
"

DEPEND="${RDEPEND}"

src_configure() {
        local mycmakeargs=(
                -DENABLE_ALSA="$(usex alsa)"
                -DENABLE_MPD="$(usex mpd)"
                -DENABLE_NETWORK="$(usex network)"
                -DENABLE_I3="$(usex i3)"
                -DENABLE_CURL="$(usex curl)"
        )
        cmake-utils_src_configure
}
