from base/arch
maintainer Kohei Takahashi <flast@flast.jp>

env HOME /root
user root
workdir /root

run pacman -Syyu --noconfirm
run pacman -S --noconfirm bash grep file tar bzip2 patch binutils gcc make tar
run curl -L https://aur.archlinux.org/packages/un/unzip-iconv/unzip-iconv.tar.gz | (cd $HOME; tar xz)
run cd $HOME/unzip-iconv; makepkg --asroot
run pacman -U --noconfirm $HOME/unzip-iconv/unzip-iconv-6.0-1-x86_64.pkg.tar.xz
