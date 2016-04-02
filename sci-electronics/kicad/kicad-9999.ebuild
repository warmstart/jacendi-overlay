# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit cmake-utils fdo-mime flag-o-matic gnome2-utils python-single-r1 wxwidgets git-2

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

LICENSE="GPL-2"
SLOT="0"

EGIT_REPO_URI="https://github.com/KiCad/kicad-source-mirror.git"

KEYWORDS="~amd64 ~x86"

IUSE="debug doc examples github minimal python gost sexpr nanometr"
LANGS="bg ca cs de el es fi fr hu it ja ko nl pl pt ru sk sl sv zh_CN"
for lang in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lang}"
done
unset lang

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	python? (
		dev-python/wxpython:${WX_GTK_VER}[opengl,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	github? ( net-misc/curl )
	>=dev-libs/boost-1.56[context,nls,threads,python?]
	media-libs/glew
	media-libs/glm
	media-libs/freeglut
	media-libs/mesa
	sys-libs/zlib
	x11-libs/cairo"
DEPEND="${CDEPEND}
	app-arch/xz-utils
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig:0 )
	app-text/dos2unix"
RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	# remove all the non unix file endings
	find "${S}" -type f -name "*.desktop" | xargs -n1 dos2unix
	assert "dos2unix failed"

	# Handle optional minimal install.
	if use minimal; then
		# remove templates as they are not needed to run binaries
		sed -e '/add_subdirectory( template )/d' -i CMakeLists.txt || die "sed failed"
	else
		# create a link to the parts library in the main project folder
		ln -s "${WORKDIR}/${P}-library" "${S}/${PN}-library" || die "ln failed"
		# add the libraries directory to cmake as a subproject to build
		sed "/add_subdirectory( bitmaps_png )/a add_subdirectory( ${PN}-library )" -i CMakeLists.txt || die "sed failed"
		# remove duplicate uninstall directions for the library module
		sed '/make uninstall/,/# /d' -i ${PN}-library/CMakeLists.txt || die "sed failed"
	fi

	# Install examples in the right place if requested
	if use examples; then
		# install demos into the examples folder too
		sed -e 's:${KICAD_DATA}/demos:${KICAD_DOCS}/examples:' -i CMakeLists.txt || die "sed failed"
	else
		# remove additional demos/examples as its not strictly required to run the binaries 
		sed -e '/add_subdirectory( demos )/d' -i CMakeLists.txt || die "sed failed"
	fi

	# Add important missing doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die "sed failed"
}

src_configure() {
	need-wxwidgets unicode

	local mycmakeargs=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DKICAD_DOCS="/usr/share/doc/${PF}"
		-DKICAD_HELP="/usr/share/doc/${PF}/help"
		-DKICAD_REPO_NAME="stable"
		-DKICAD_BUILD_VERSION="${PV}"
		-DwxUSE_UNICODE=ON
		-DKICAD_SKIP_BOOST=ON
		-DKICAD_TESTING_VERSION=on
		-DKICAD_CYRILLIC=ON
		$(cmake-utils_use github BUILD_GITHUB_PLUGIN)
		$(cmake-utils_use python KICAD_SCRIPTING)
		$(cmake-utils_use python KICAD_SCRIPTING_MODULES)
		$(cmake-utils_use python KICAD_SCRIPTING_WXPYTHON)
		$(cmake-utils_use gost KICAD_GOST)
		$(cmake-utils_use sexpr USE_PCBNEW_SEXPR_FILE_FORMAT)
		$(cmake-utils_use nanometr USE_PCBNEW_NANOMETRES)
	)
	if use debug; then
		append-cxxflags "-DDEBUG"
		append-cflags "-DDEBUG"
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize

	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die "cd failed"
		dodoc -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/.
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge ${PN} without the 'minimal' USE flag."
	fi
	elog ""
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
	elog "For help and extended documentation emerge app-doc/kicad-doc."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
