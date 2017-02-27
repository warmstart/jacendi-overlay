# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils git-r3

DESCRIPTION="A simulator for the Atmel AVR family of microcontrollers"
HOMEPAGE="http://www.nongnu.org/simulavr/"
EGIT_REPO_URI="git://git.savannah.nongnu.org/simulavr.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="verilog python tcl doc"

RDEPEND="sys-libs/ncurses"

DEPEND="${RDEPEND}
        >=dev-lang/swig-2.0.0
        doc? ( app-doc/doxygen[dot] dev-python/sphinx )
        python? ( >=dev-lang/python-2.7 )
        tcl? ( dev-lang/tcl dev-tcltk/itcl )
        verilog? ( sci-electronics/iverilog )"

pkg-setup()
{
    if !has_version cross-avr/gcc; then
        eerror "${PN} requires avr-gcc to be installed."
        eerror "You can install it by running:"
        eerror " crossdev -t avr"
        die "Missing avr-gcc"
    fi

    if !has_version cross-avr/binutils; then
        eerror "${PN} requires avr-binutils to be installed"
        eerror "You can install it by running:"
        eerror " crossdev -t avr"
	eerror "Gentoo bug #147155 hot-fix:"
	eerror "Create a symlink to /usr/avr/lib/ldscripts"
        eerror "ln -s /usr/${CHOST}/avr/lib/ldscripts /usr/avr/lib/ldscripts"
        die "Missing avr-binutils"
    fi
}

src_prepare()
{
	if [[ "${PV}" == "9999" ]]; then
	   ./bootstrap
	fi

	eapply_user
}

src_configure()
{
    local my_conf="--enable-dependency-tracking"
    local BINUTILS=$(binutils-config --get-current-profile avr)
    local BINUTILS_CONFIG="/etc/env.d/binutls/${BINUTILS}"
    local BINUTILS_PATH=$(sed -n 's/^LIBPATH="\(.*\)"$/\1/p' "${BINUTILS_CONFIG}")
    my_conf="${my_conf} --with-bfd=${BINUTILS_PATH}"
    my_conf="${my_conf} $(use_enable python)"
    my_conf="${my_conf} $(use_enable tcl)"
    my_conf="${my_conf} $(use_enable verilog)"
    my_conf="${my_conf} $(use_enable doc doxygen-doc)"
    my_conf="${my_conf} $(use_enable doc doxygen-html)"
    LDFLAGS="-Wl,-rpath=${BINUTILS_PATH},--enable-new-dtags ${LDFLAGS}" econf ${my_conf} --docdir="${EPREFIX}/usr/share/doc/${PF}"
    econf ${my_conf}
}

src_compile()
{
    emake

    if use doc; then
        make web-html
        make doxygen-doc
    fi
}

src_install()
{
    emake DESTDIR="${D}" install

    if use doc; then
        dohtml -r doc/web_build/html/*
        _E_DOCDESTTREE_="doxygen" dohtml -r doc/doxygen-doc/html/*
    fi
}
