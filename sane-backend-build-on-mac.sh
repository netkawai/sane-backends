tar xvfz m4-1.4.19.tar.gz
cd ./m4-1.4.19
./configure --prefix=$HOME/.local --disable-nls
make & make install
cd ..
tar xvfz autoconf-2.72.tar.gz
cd ./autoconf-2.72
./configure --prefix=$HOME/.local
make & make install
cd ..
tar xvfz automake-1.16.5.tar.gz
cd ./automake-1.16.5
./configure --prefix=$HOME/.local
make & make install
cd ..
tar xvfz libtool-2.4.7.tar.gz
cd ./libtool-2.4.7
./configure --prefix=$HOME/.local
make & make install
cd ..
tar xvfJ autoconf-archive-2024.10.16.tar.xz
cd ./autoconf-archive-2024.10.16
make & make install
cd ..
tar xvfJ pkgconf-2.3.0.tar.xz
cd ./pkgconf-2.3.0
./configure --prefix=$HOME/.local --disable-nls
make & make install
ln -s $HOME/.local/bin/pkgconf $HOME/.local/bin/pkg-config
ln -s $HOME/.local/share/man/man1/pkgconf.1 $HOME/.local/share/man/man1/pkg-config.1
cd ..
tar xvfz jpegsrc.v9f.tar.gz
cd ./jpeg-9f	
./configure --prefix=$HOME/.local
make & make install
cd ..
tar xvfz libpng-1.6.58.tar.gz
cd ./libpng-1.6.58
./configure --prefix=$HOME/.local
make & make install
cd ..

				
cd sane-backends

# patch out GETTEXT
printf "g/AM_GNU_GETTEXT/s/^/dnl /\nw\nq\n" | ed -s configure.ac

# 1. Clear out the broken compilation states
git clean -fdx


# create dummy po folder and dummy file
mkdir -p po
cp $HOME/.local/share/automake-1.16/COPYING po/Makefile.in.in

# 2. Run your low-level layout compilers in structural order
$HOME/.local/bin/aclocal --force -I m4 -I $HOME/.local/share/aclocal
$HOME/.local/bin/libtoolize --copy --force
$HOME/.local/bin/autoheader --force
$HOME/.local/bin/autoconf --force
$HOME/.local/bin/automake --add-missing --copy --force-missing


./configure --prefix=$HOME/.local \
            --disable-nls \
            --enable-network \
            CPPFLAGS="-I/Users/kawai/.local/include" \
            LDFLAGS="-L/Users/kawai/.local/lib"



echo "all:\n\t@echo 'Bypassing translation build'\n\ninstall:\n\t@echo 'Bypassing translation install'" > po/Makefile

make 
make install
