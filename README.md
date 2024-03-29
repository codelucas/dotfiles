This repository contains my command line environment settings, hence "dotfiles". This setup is
optimized for OSX and Ubuntu environments. I don't recommend replicating this setup if you are
other operating systems.


Installation:
-------------
- Install zsh (needed before next step)
    * `sudo apt install zsh`
    * https://www.tecmint.com/install-zsh-in-ubuntu/
- [Install oh-my-zshrc](https://github.com/robbyrussell/oh-my-zsh#basic-installation)
    * `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"` or
        `sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"`
- Run command to install ubuntu packages (mosh, pip, hg, flake8)
    * `./ubuntu_setup.sh`
- Install dircolors because my setup relies on that to display colors properly
    * Run `brew install coreutils`, which installs dircolors among other things
- Move all dot scripts to their proper locations:
    * `cp /path/to/repo/dotfiles/.zshrc ~/.zshrc`
    * `cp /path/to/repo/dotfiles/.dircolors ~/.dircolors`
    * `cp /path/to/repo/dotfiles/.gitconfig ~/.gitconfig`
- Set zsh as your default shell
    * `chsh -s /bin/zsh`
- *(OSX specific instructions)* Finally to make sure the OSX terminal colors are proper, use my custom solarized terminal colors here:
    * Open up either of the `.terminal` theme files in the osx-pallets folder provided and run it. Then open terminal preferences.
      Solarized Dark should be a profile option. Select it and set as default. Ensure that the terminals are declared as **xterm-256color**
- Finally, install the Sublime 3 color schemes.
    * Make sure you install [Package Control](https://packagecontrol.io/installation)
    * Use package control to install PackageResourceViewer
    * Install the 3024 light and Soda Light 3 themes if not already installed
    * CMD + Shift + p => UI: Select Theme => Soda Light 3
    * CMD + Shift + p => UI: Select Color Scheme => 3024 Day
    * Copy in the provided 3024 Day.tmTheme file provided in this repo into its proper location, find via PackageResourceViewer
    * Copy the provided Preferences.sublime-settings file into the proper location under settings via CMD + ,

If your directory and other files do not display colors for the `ls` command,
make sure `dircolors` is installed with `sudo apt-get install dircolors`.
On OSX, use `brew install coreutils`.

If you are interested in my VIM setup, which is tailored for this dotfile setup, please see [this link](https://github.com/codelucas/vimrc)

Still have questions? Feel free to contact me at [https://codelucas.com](https://codelucas.com)
