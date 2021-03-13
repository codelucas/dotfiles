# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="af-magic"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git hg osx sublime pip)

source $ZSH/oh-my-zsh.sh

# User configuration

# Keep the regular font and color scheme in tmux
if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    export TERM=screen-256color
fi

# Colorful grep searches
export GREP_OPTIONS='--color=always'
export GREP_COLOR='01;31'

export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
# if on M1 macbook, uncomment:
# export PATH=/opt/homebrew/bin:$PATH

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='vim'
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Aliases
# GNU coreutils aliased to regular commands, only if on OSX.
# These commands should be installed via brew.

prefix=''
if [ "$(uname)" = "Darwin" ]; then
    prefix='g'
fi

alias dircolors=$prefix'dircolors'
alias ls=$prefix'ls -h --color=auto'
alias ll=$prefix'ls -alFh --color=auto'
alias la=$prefix'ls -Ah --color=auto'
alias l=$prefix'ls -CFh --color=auto'


java7() {
  export JAVA_HOME=`/usr/libexec/java_home -v 1.7.0_80`
  echo "Changed JDK version to 1.7.0_80";
}

java8() {
  export JAVA_HOME=`/usr/libexec/java_home -v 1.8`;
  echo "Changed JDK version to 1.8";
}


# ################################################
# ################################################

bold=$(tput bold)
normal=$(tput sgr0)

# case-insensitive, relative to current directory, filename customizable
# param 1 (required): text to grep in current directory (and recursively downwards)
# param 2 (optional): file extension type ("py" for python, "java" for java
smart_ripgrep() {
  if [ $# -eq 1 ]; then
    rg -i "$1" -tjava
  fi
  if [ $# -eq 2 ]; then
    rg -i "$1" -t$2
  fi
}


git_smart_force_push() {
  # Standard mechanism for updating a PR on Github.
  # This strategy works best with a "one commit per PR" strategy, always:
  # (1) Commit once, amend it till the end of the PR
  # (2) Always force push because git history
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch_name="(unnamed branch)"     # detached HEAD

  branch_name=${branch_name##refs/heads/}
  # this can also work with git config --global push.default current
  git push -f --set-upstream origin $branch_name
}

git_commit_amend() {
  git add .;
  git commit --amend -a;
}

git_commit() {
  git add .;
  git commit -a;
}

git_clear_local_branches() {
  echo "Deleting all local git branches but master and switching to master!";
  echo "Press enter to continue ..";
  read;
  git checkout master;
  git --no-pager branch | grep -v "master" | xargs git branch -D;
}

git_delete() {
  echo "Deleting local branch $1 permanently! Press enter to continue ...";
  read;
  git branch -D "$1";
}

git_smart_switch_or_create_branch() {
  if [ $# -eq 0 ]; then
    # sfeature with no args lists all branches
    git --no-pager branch;
    return;
  fi

  if [ `git --no-pager branch --list $1` ]; then
    echo "Switching to existing branch '$1'";
    git checkout "$1";
  else
    if [[ "$1" = "master" ]]; then
      echo "Specify a name other than master!";
      return;
    fi
    echo "Creating and switching to new branch '$1'";
    git checkout -b "$1";
  fi
  echo "Directory of existing branches:";
  git --no-pager branch;
}

git_smart_pull() {
  old_branch=$(git --no-pager branch | sed -n -e 's/^\* \(.*\)/\1/p');

  if [ $# -eq 0 ]; then
    echo "Checking out master";
    git checkout master;

    echo "Pulling latest commits from origin"
    git pull origin master;
  else
    echo "Checking out $1";
    git checkout "$1";

    echo "Pulling latest commits from origin"
    git pull origin "$1";
  fi

  echo "Moving back to $old_branch";
  git checkout $old_branch;

  echo "Rebasing $old_branch on top of master";
  git rebase master;
}

smart_file_find() {
  # Find matching case in-sensitive filenames recursively
  # ignore build files, class files, and etc.
  # grep's purpose in this line just colorizes find's output.
  find . -iname "*$1*" \
      -and -not -path "*build*" \
      -and -not -path "*.class" \
      -and -not -path "./\.git*" \
      -and -not -path "./out*" \
    | grep -i "$1";
}

smart_file_open() {
  file_path_original=$(smart_file_find "$1");

  # remove color ansi escape codes
  file_path_no_colors="$(echo -e "${file_path_original}" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g')";

  # remove whitespace
  file_path_no_ws="$(echo -e "${file_path_no_colors}" | tr -d '[:space:]')";

  if [[ -z $file_path_no_ws ]]; then
    echo "File matching $1 not found!";
    return;
  fi

  # abort if >1 files were found
  num_files=$(echo $file_path_no_colors | wc -l);
  if [[ $num_files -gt "1" ]]; then
    echo "More than one file matched!\n$file_path_original";
    return;
  fi

  vim $file_path_no_ws;
}

git_pull_remote() {
  if [ $# -lt 2 ]; then
    echo "Please provide inputs <remote branch> <new local branch>! To pull from remote to local";
    return;
  fi
  git fetch origin $1:$2;
  git checkout $2;
}

git_squash_n() {
  git rebase --interactive HEAD~$1
}

git_smart_log() {
  if [ $# -eq 0 ]; then
    # By default, show the previous 20 commits in the log.
    num_commits_lookback=50
  else
    # Otherwise show the custom input in the first parameter.
    num_commits_lookback=$1
  fi
  git log --graph --full-history --abbrev-commit -$num_commits_lookback --all --color \
      --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s%Cblue %an";
}


alias spush=git_smart_force_push
alias sclear=git_clear_local_branches
alias spull=git_smart_pull
alias sfeature=git_smart_switch_or_create_branch
alias amend=git_commit_amend
alias commit=git_commit
alias gitsl=git_smart_log
alias gl=git_smart_log

alias vpn=vpn_connect
alias google_login="gcloud auth login"
alias gradle=./gradlew

alias sgrep=smart_ripgrep
alias sfind=smart_file_find
alias sopen=smart_file_open
alias srpull=git_pull_remote
alias clear_git="git checkout -- ."
alias d="git diff"
alias da="git diff master..HEAD"
alias d0="git diff HEAD"
alias d1="git diff HEAD^"
alias ccc="git checkout -- ."
alias sf="sfeature"
alias gd=git_delete

alias v="vim"

alias ggrep="git grep --break --heading --line-number $1 -- $2"


# ################################################
# ################################################

# Enable color support of ls
# Create ~/.dircolors from https://github.com/codelucas/dotfiles/blob/master/.dircolors
# if on M1 macbook, replace "/usr/local/bin/" with "/opt/homebrew/bin/"
if [ -x /usr/local/bin/$dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Automatically reload .zshrc after editing it
alias reload_zsh=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias zshrc="$EDITOR ~/.zshrc && reload_zsh"

# SCP example:
# scp -P <PORT> <LOCAL_FILE> <USER>@<IP>:/path/to/destination

# SSH example:
# mosh <USER>@<IP> -ssh="ssh -p <PORT>"

export PATH=$PATH:/usr/local/go/bin 
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"

alias git_refresh_remote="git fetch origin && git reset origin/$1 --hard"

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
