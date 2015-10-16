# Install the vim and cppenviron.
# * It's contains software:
#       dos2unix
#       git
#       vim
#       g++
#       ctags
#       cmake
#       python-dev
#       vim-YouCompleteMe
#       vim-vundle
#       vim-airline
#       vim-nerdtree
#       vim-taglist
#       vim-cppenv.
#
# * And contains config files:
#       _vimrc
#       .ycm_extra_conf.py
#

# install dos2unix, git, vim, g++, ctags, cmake, python-dev
./change_source_list.sh

VUNDLE_GIT=https://github.com/gmarik/Vundle.vim.git
YCM_GIT=https://github.com/Valloric/YouCompleteMe.git

set -e

INSTALL_TOOL=apt-get
PY_NAME=python-dev
if [ `which apt-get 2>/dev/null | wc -l` -eq 0 ] ; then
    INSTALL_TOOL=yum
    PY_NAME=python-devel
fi
echo $INSTALL_TOOL

sudo $INSTALL_TOOL update -y

dos2unix --version || sudo $INSTALL_TOOL install dos2unix -y
dos2unix --version || exit 1

git --version || sudo $INSTALL_TOOL install git -y
git --version || exit 1
git config --global user.email user_email@gmail.com
git config --global user.name user_name

vim --version || sudo $INSTALL_TOOL install vim -y
vim --version || exit 1

g++ --version || sudo $INSTALL_TOOL install g++ -y
g++ --version || exit 1

ctags --version || sudo $INSTALL_TOOL install ctags -y
ctags --version || exit 1

cmake --version || sudo $INSTALL_TOOL install cmake -y
cmake --version || exit 1

sudo $INSTALL_TOOL install $PY_NAME -y

# copy _vimrc file to $HOME
dos2unix _vimrc
rm ~/_vimrc -f
ln _vimrc ~/_vimrc
chmod 0666 ~/_vimrc
dos2unix .ycm_extra_conf.py
rm ~/.ycm_extra_conf.py -f
cp .ycm_extra_conf.py ~/
chmod 0666 ~/.ycm_extra_conf.py

# git clone vim-vundle.git
vim_path=`vim --version | grep '$VIM:' | cut -d'"' -f2`
vundle_path=${vim_path}/vimfiles/bundle/Vundle.vim
#echo $vim_path
#echo ${vundle_path}
while true
do
    if test -d ${vundle_path}; then
        cd ${vundle_path}
        sudo git pull && break
    else
        sudo git clone ${VUNDLE_GIT} ${vundle_path} && break
    fi
done

# gitclone and compile YouCompleteMe
ycm_path=${vim_path}/vimfiles/bundle/YouCompleteMe
while true
do
    if test -d ${ycm_path}; then
        cd ${ycm_path}
        sudo git pull && break
    else
        sudo git clone ${YCM_GIT} ${ycm_path} && break
        cd ${ycm_path}
    fi
done

while true
do
    sudo git submodule update --init --recursive && break
done

sudo ./install.sh --clang-completer || exit 3

# install vim-plugins
sudo vim +BundleInstall -c quitall

echo 'vim-env is ok, good luck!'

