# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit git-r3 distutils-r1 eutils

DESCRIPTION="Translate a resistor color codes into readable value"
HOMEPAGE="https://github.com/roroid/gResistor2"
EGIT_REPO_URI="https://github.com/roroid/gResistor2.git"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygobject:3
	dev-python/lxml"
RDEPEND="${DEPEND}"

src_prepare()
{
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	newicon icon.svg ${PN}.svg
	domenu ${PN}.desktop
}
