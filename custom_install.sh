#!/bin/bash

# Directory where packages will be stored
DEST=/home/user/root

# Temp file to store dependencies
DEPENDENCIES=/tmp/custom.deps

# Temp directory to place built package
# THIS DIR CAN BE REMOVED!
TMPDIR=/tmp/custom-install


help() {
echo "Downloads or builds packages to a custom folder and links them to system folders.

	usage: custom_install.sh <operation>

	-a --aur:     Builds a package from AUR (needs yaourt) (dependencies still not handled)
	-r --repo:    Downloads a package and its dependencies from common repositories (uses pacman)
	-i --install: Links downloaded or built files to system folders

	Use --aur or --repo with ONE PACKAGE AT A TIME!
	Don't forget to run --install after --aur or --repo!

	Examples:
	    custom_install.sh --aur jre
	    custom_install.sh --repo wine
	    custom_install.sh --install

	When using in an AppVM, you'll need to run --install after every reboot, so files 
	stored will be linked to system folders. But it should be much faster than downloading
	or building everything after every reboot.

	Some programs may need extra steps to be properly installed. For exemple, the "jre" 
	AUR package also needs:
	    sudo archlinux-java set java-8-jre/jre
"
}


from_aur() {
    # Builds a package from AUR (needs yaourt)
    cd /tmp
    yaourt --getpkgbuild $1
    sed -i 's@$pkgdir@'$DEST@g $1/PKGBUILD
    cd $1
    makepkg
}


from_repositories() {
    # Downloads a package and its dependencies from 
    # common repositories (uses pacman)
    pacman -Sp $1 > $DEPENDENCIES
    mkdir $TMPDIR
    wget -P $TMPDIR -i $DEPENDENCIES
    for i in $TMPDIR/*; do echo $i; tar -xf $i -C $DEST; done
    rm -rf $TMPDIR
}


install_linking() {
    # Link files to system folders
    sudo cp -rs $DEST/* /
}


case $1 in
    -a|--aur)
         from_aur $2 
         ;;
    -r|--repo)
         from_repositories $2 
         ;;
    -i|--install)
         install_linking
         ;;
    *)
         help
         ;;
esac
