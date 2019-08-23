#!/usr/bin/env zsh

source resources.sh

bot "hello! welcome to your new computer"
bot "let's get going! "

bot "installing osx command line tools"
xcode-select --install

# set computer info
set_computer_info

# copy dotfiles
mkdir ~/.dotfiles/
cp config/.* ~/.dotfiles/
cp .zshrc ~/.dotfiles/

# homebrew
if [ -x /usr/local/bin/brew ];
then
    running "Skipping install of brew. It is already installed.";
    running "Updating brew..."
    brew update;
    running "Updated brew."
    ok
else
    running "installing brew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
        error "unable to install homebrew -> quitting setup"
        exit 2
    fi
    ok
fi

running "Running brew bundle...";
brew bundle;
if [[ $? != 0 ]]; then
        error "brew bundle could not complete"
        exit 2
fi
ok "brew bundle complete";

bot "installing go tools"
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
mkdir -p $GOPATH/src $GOPATH/pkg $GOPATH/bin
go get -u github.com/derekparker/delve/cmd/dlv
ok

running "downloading oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ok oh-my-zsh

running "downloading Meslo Font"
wget --quiet https://raw.githubusercontent.com/powerline/fonts/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf -P ~/Downloads/
ok "Meslo Font"

# hard link .zshrc
running "linking your .zshrc!"
ln ~/.dotfiles/.zshrc ~/.zshrc
ok

# hard link .gitconfig
running "linking .gitconfig"
ln ~/.dotfiles/.gitconfig ~/.gitconfig
ok

# hard link .gitignore
running "linking .gitignore"
ln ~/.dotfiles/.gitignore ~/.gitignore
ok

bot "setting zsh as the user shell"
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
    bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
    sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
    ok
fi

running "sourcing zshrc"
source ~/.zshrc
ok
SSH_Keygen
bot "Setup complete";
