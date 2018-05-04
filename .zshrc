HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
export TERM=xterm-256color
DEFAULT_USER=dingus
export EDITOR=vim
export KEYTIMEOUT=1           # .1 sec to switch vi-modes
export PATH="$PATH:${HOME}/bin"


POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode context dir  background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs)
POWERLEVEL9K_BACKGROUND_JOBS_ICON='\u2699'
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND="249"
POWERLEVEL9K_VI_INSERT_MODE_STRING="INS"
POWERLEVEL9K_VI_COMMAND_MODE_STRING="NORM"
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='green'
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='black'
POWERLEVEL9K_STATUS_VERBOSE=false


autoload -U zle-keymap-select
autoload -U edit-command-line
autoload -U compinit complete complist computil    # Enable completion support.
autoload -U promptinit                             # Prompt customization support.
autoload -U colors                                 # Enable color support.
autoload -U regex                                  # Enable regex support.
colors && compinit -u && promptinit

source .config/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
bhilburn/powerlevel9k
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
joel-porquet/zsh-dircolors-solarized.git
git
git-extras
docker
docker-compose
docker-machine
systemd
vi-mode
EOBUNDLES
antigen theme bhilburn/powerlevel9k powerlevel9k
antigen apply


# setup dircolors if they haven't been loaded
if [[ ! -f ~/.zsh-dircolors.config ]]
then setupsolarized dircolors.ansi-dark
fi

alias ls='ls --color=auto'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lS='ls -1FSsh'
alias lart='1Fcart'
alias lrt='1Fcrt'
alias h=' history | tail -n 50'
alias hgrep=' history | grep'
alias vimt='vim $(ls -t | head -1)'

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt CORRECT
setopt IGNORE_EOF
setopt MULTIOS                  # Allow piping to multiple outputs.
setopt NO_BEEP
setopt NO_FLOW_CONTROL
setopt NO_HUP
setopt AUTO_CD
setopt AUTO_PUSHD               # cd = pushd.
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt RC_EXPAND_PARAM          # foo${a b c}bar = fooabar foobbar foocbar instead of fooa b cbar.
setopt NO_CLOBBER		
setopt COMPLETE_IN_WORD    # Try to complete from cursor.
setopt GLOB_COMPLETE
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT   # Glob sorting is primarily numeric.
setopt AUTO_NAME_DIRS
setopt PRINT_EXIT_VALUE
setopt CHECK_JOBS
setopt NOTIFY
setopt INC_APPEND_HISTORY

# alias help to run-help; find out about builtins, or load man page for ext stuff
unalias run-help
autoload -Uz run-help
alias help='run-help'


# helpers for longer stuff i.e. 'help ip a' shows stuff for 'ip a' and not just 'ip'
autoload -Uz run-help-sudo
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl

bindkey " " magic-space

# 10 second wait if you do something that will delete everything. 
setopt RM_STAR_WAIT

# alt-s to insert sudo at beginning of line
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

#enable cmd line editing in $EDITOR; bind z to edit cmd line when in command mode
zle -N edit-command-line
bindkey -M vicmd z edit-command-line
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward
bindkey -M vicmd "q" push-line

# up/down arrows will complete based on matches with existing text
bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -sM vicmd '^[' '^G'             # bind something to esc so it wont eat chars

# stuff to make vi mode indicator work on current pl9k version
function zle-line-init {
  powerlevel9k_prepare_prompts
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  zle reset-prompt
  zle -R
}

function zle-line-finish {
  powerlevel9k_prepare_prompts
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi
  zle reset-prompt
  zle -R
}

function zle-keymap-select {
  powerlevel9k_prepare_prompts
  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N ale-line-finish
zle -N zle-keymap-select

prompt_context() {
  if [[ "$USER" == "$DEFAULT_USER" ]]; then
      "$1_prompt_segment" "$0_BUTTES" "$2" "$DEFAULT_COLOR" "011" "%m"
  elif [[ $(print -P "%#") == '#' ]]; then
      # Shell runs as root
    "$1_prompt_segment" "$0_ROOT" "$2" "$DEFAULT_COLOR" "red" "$USER@%m"
  else
    "$1_prompt_segment" "$0_DEFAULT" "$2" "$DEFAULT_COLOR" "011" "$USER@%m"
  fi
}
prompt_status() {
  if [[ "$POWERLEVEL9K_STATUS_VERBOSE" == true ]]; then
    if [[ "$RETVAL" -ne 0 ]]; then
      "$1_prompt_segment" "$0_ERROR" "$2" "red" "226" "$RETVAL" 'CARRIAGE_RETURN_ICON'
      "$1_prompt_segment" "$0_OK" "$2" "$DEFAULT_COLOR" "046" "" 'OK_ICON'
    fi
  else
    if [[ "$RETVAL" -ne 0 ]]; then
      "$1_prompt_segment" "$0_ERROR" "$2" "$DEFAULT_COLOR" "red" "$RETVAL" 'FAIL_ICON'
    fi
  fi
}
