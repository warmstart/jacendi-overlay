# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit git-2 distutils eutils

PYTHON_DEPEND="2:2.7"

DESCRIPTION="Translate a resistor color codes into readable value"
HOMEPAGE="https://github.com/roroid/gResistor2"
EGIT_REPO_URI="https://github.com/roroid/gResistor2.git"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
		dev-python/pygobject:3
		dev-python/lxml"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	distutils_src_install
	newicon icon.svg ${PN}.svg
	domenu ${PN}.desktop
}
