# VARIABLES
export EDITOR=vim
bindkey -e # tmux fix <https://superuser.com/questions/750965/tmux-printing-p>
export GPG_TTY=$(tty)

# Work specific
[ -e "$HOME/.wprc.sh" ] && source $HOME/.wprc.sh
# GIT STUFF
# Git push the current branch. Use -o to open the merge request in a browser
gpb() {
  branch=$(git branch | grep \* | sed -e "s/\* \(.*\)/\1/")
        echo "Pushing to remote $branch"
        git push origin -u $branch |& tee /tmp/mrgout
        url=$(cat /tmp/mrgout | grep merge_request | sed -e "s/remote:\s*//")
        if [[ $# -eq 1 && "$1" == "-o" || "$1" == "--open" ]]; then
            open $url
        else
            echo "########"
            echo $url
            echo "########"
        fi
}

# Cleanup git branches, uses grep so regex works fine
gbrm() {
    query=feature
    if [ -n $1 ]; then
      query=$1
    fi
    for f in $(git branch | grep $query); do git branch  -d $f; done
}

gitrefresh() {
    main_branch=$(git branch | grep "master" > /dev/null && echo master || echo main)
    git checkout $main_branch && git pull && git checkout - && git merge $main_branch -m "merge with $main_branch"
}

# CONVENIENCE FUNCS
# How long does it take to read through a document?
readtime() {
    fastPace=500
    medPace=250

    words=$(wc -w < $1)
    fastTimeS=$(echo $((words / $fastPace.0 * 60)))
    fastTimeS=$(printf "%.0f" $fastTimeS)
    medTimeS=$(echo $((words / $medPace.0 * 60)))
    medTimeS=$(printf "%.0f" $medTimeS)

    echo "Fast ($fastPace wpm): $((fastTimeS / 60))m$((fastTimeS % 60))s."
    echo "Medium ($medPace wpm): $((medTimeS / 60))m$((medTimeS % 60))s."
}

myip() {
    case $1 in
        l)
            ip=$(ipconfig getifaddr en0)
            ;;
        p)
            ip=$(curl -s ifconfig.me)
            ;;
        *)
            echo "script to get my local or public IP"
            echo "Usage: myip {l|p}"
            return
            ;;
    esac
    echo $ip
}

update_finances() {
    curl -m 70 -X POST https://europe-north1-shoveling.cloudfunctions.net/drive-reader \
    -H "Authorization: bearer $(gcloud auth print-identity-token)" \
    -H "Content-Type: application/json" \
    -d '{
      "dst_table": "shoveling.habits.transactions"
    }'
}

# ALIASES
# GIT 
alias ga="git add"
alias gap="git add -p"
alias gb="git branch"
alias gc="git commit"
alias gce="git checkout"
alias gceb="git checkout -b"
alias gd="git diff"
alias gdp="git diff HEAD~1" # Diff with previous commit
alias glo="git log --oneline"
alias gcam="git commit -a -m"
alias gcm="git commit -m"
alias gpl="git pull origin"
alias gp="git push"
alias gs="git status"
alias trigger_ci='git commit -m "trigger ci" --allow-empty && git push'

# NAVIGATION
alias cd.="cd .."
alias cdw="cd ~/ws/"
alias cdwe="cd ~/ws/webben/"
alias l="ls -lah --color=auto"
# Let zsh deal with ls alias and coloring

# SHORTHAND
alias clean_swps="find . -type f -name *.swp -delete"
alias pjson="python -m json.tool"
alias py="python3"
alias tf="terraform"
alias todo="vim ~/todo.md"
alias wl="vim ~/worklog.md"
alias garden="vim -c ':normal 11jo## ttoday' ~/garden.md"
alias lspath='echo $PATH | tr ":" "\n"'
alias rss="newsboat"
alias k='kubectl'
alias ekotids='curl -s https://news-service.sr.se/feed/ekot | jq ".articles[].id"'
alias lunch='uvx --from git+https://github.com/engdahl/rhlunch lunch'
alias copil='copilot --allow-all-tools'
alias gemiy='gemini --yolo'
alias tmuxit='tmux new-session -d -s workspace -n server \; new-window -n editor \; new-window -n agent \; attach-session -d'
alias oc='opencode'

# PATH
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# Go-path
export PATH="/Users/vibo/go/bin:$PATH"
# Python path
export PATH="/Users/vibo/Library/Python/3.9/bin:$PATH"

# AUTOCOMPLETE
# [[ $commands[kubectl] ]] && source <(kubectl completion zsh) 
# complete -o default -F __start_kubectl k

# zsh stuffs
setopt  autocd autopushd
autoload -U compinit
compinit

# pnpm
export PNPM_HOME="/Users/vibo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/vibo/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# PROMPT
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '(%b)%u%c'

## Set up the prompt (with git branch name)
setopt PROMPT_SUBST

PROMPT='%F{green}%~%F{yellow} ${vcs_info_msg_0_} %(?.%F{green}√.%F{red}?%?)%f $ '
RPROMPT='%F{grey}%*%f'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vbodell/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vbodell/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vbodell/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vbodell/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity
export PATH="/Users/vbodell/.antigravity/antigravity/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
