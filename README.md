# custom_install
Downloads or builds packages to a custom folder and links them to system folders.

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
