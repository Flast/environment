# ヒストリ関係
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# vim キーバインド
bindkey -v

# プロンプト
_reset="%b"
red="%{[31m%}"
green="%{[32m%}"
blue="%{[36m%}"

_zshrc__is_v6() {
    # TODO
    true
}

_zshrc__over_ssh() {
    [[ -n $SSH_CLIENT ]]
}

_zshrc__prompt_ssh_client() {
    read a p d < <(echo $SSH_CLIENT)

    a="$red$a$_reset"
    if _zshrc__is_v6 $a; then
        a="[$a]"
    fi
    echo "$a:$p"
}

_zshrc__update_git_branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ $branch = HEAD ]]; then
        _zshrc__GIT_CURRENT_BRANCH=":(detached HEAD)"
    elif [[ -n $branch ]]; then
        _zshrc__GIT_CURRENT_BRANCH=":$branch"
    else
        _zshrc__GIT_CURRENT_BRANCH=""
    fi
}

_zshrc__update_prompt() {
    if _zshrc__over_ssh; then
        PROMPT="$(_zshrc__prompt_ssh_client) -> $green%n$_reset@$red%M$_reset
"
    else
        PROMPT="$red%m$_reset:"
    fi

    _zshrc__update_git_branch
    PROMPT="$PROMPT%(?.$blue.$red)%~$_reset$_zshrc__GIT_CURRENT_BRANCH"

    PROMPT="%U$PROMPT%u
%(!.#.\$) "
}

PROMPT2="> "
RPROMPT="[%D %T]"
SPROMPT="%r is correct? [n,y,a,e]: "

precmd() { _zshrc__update_prompt }
chpwd() { _zshrc__update_prompt }

# 表示色関係
autoload colors
colors

setopt auto_pushd
setopt nobeep
setopt nolistbeep

setopt list_packed

# 補完関係
autoload -U compinit
compinit
setopt correct
setopt correctall
setopt complete_aliases
setopt noautoremoveslash
setopt nonomatch

# environments
_zshrc__has_terminfo() {
    local head=$(echo $1 | sed -n 's/^\(.\).*$/\1/p')
    [[ -f /usr/share/terminfo/$head/$1 ]]
}
_zshrc__has_terminfo_256color() {
    [[ "$TERM" = $3 ]] && _zshrc__has_terminfo $1
}

if [[ "$COLORTERM" = "gnome-terminal" ]] \
|| _zshrc__has_terminfo_256color "gnome-256color" if "gnome-terminal"; then
    export _zshrc__OLDTERM="$TERM"
    export TERM="gnome-256color"
elif _zshrc__has_terminfo_256color "xterm-256color" if "xterm"; then
    export _zshrc__OLDTERM="$TERM"
    export TERM="xterm-256color"
elif _zshrc__has_terminfo_256color "screen-256color" if "screen"; then
    export _zshrc__OLDTERM="$TERM"
    export TERM="screen-256color"
fi

export EDITOR=vim
export SVN_EDITOR=vim
export HGEDITOR=vim

export LANG=en_GB.utf8

# alias

_zshrc__test_binary() {
    [[ -x $(which --skip-alias "$1") ]] >/dev/null 2>&1
}

_zshrc__test_executable() {
    if [[ -x /usr/bin/which ]]; then
        ( alias | /usr/bin/which --read-alias --read-functions "$1" ) >/dev/null 2>&1
    else
        which "$1" >/dev/null 2>&1
    fi
}

_zshrc__test_and_alias() {
    if _zshrc__test_executable "$2"; then
        local cmd=$1
        shift 1
        alias $cmd="$*"
    fi
}

# core tools (!= coreutils)
if _zshrc__test_executable dircolors; then
# GNU ls
    eval "$(dircolors -b $([[ -r ~/.dircolors ]] && echo ~/.dircolors))"
    _zshrc__AUTOCOLOR="--color=auto"
else
# BSD ls
    _zshrc__AUTOCOLOR="-G"
fi

alias grep="grep -n --color=auto"
alias egrep="egrep -n --color=auto"
alias igrep="grep -i"

alias more="more -d"
alias less="less -R"

alias ls="ls $_zshrc__AUTOCOLOR -F"

alias ll="ls -lhi"
alias la="ls -A"
alias lla="ll -a"

alias mkdir="mkdir -p"

alias rm="rm -r"
alias mv="mv -i"
alias cp="cp -Rp"

alias df="df -h"
alias du="du -ch"

alias pstree="pstree -alpuU"

_zshrc__test_and_alias tmux tmux -2

if _zshrc__test_executable nkf; then
    alias nkf-euc-jp="nkf --oc=euc-jp"
    alias nkf-sjis="nkf --oc=sjis"
fi

_zshrc__test_and_alias automake automake -a --foreign

# Compilers
_zshrc__CFLAGS="-Wall -Wextra -pedantic -g -Wno-unused-parameter"

_zshrc__CCFLAGS="-std=gnu99 $_zshrc__CFLAGS -lm"
_zshrc__CXXFLAGS="-std=gnu++11 $_zshrc__CFLAGS"

_zshrc__LDFLAGS="--as-needed"
_zshrc__LINKERFLAGS="--as-needed" # should be comma separated
_zshrc__test_and_alias ld ld $_zshrc__LDFLAGS

_zshrc__GNUFLAGS="-Winit-self -fopenmp -fmax-errors=5 -Wformat=2 -Wl,$_zshrc__LINKERFLAGS"
_zshrc__test_and_alias gcc gcc $_zshrc__CCFLAGS $_zshrc__GNUFLAGS -fcond-mismatch
_zshrc__test_and_alias g++ g++ $_zshrc__CXXFLAGS $_zshrc__GNUFLAGS

_zshrc__LLVMFLAGS="-Wl,$_zshrc__LINKERFLAGS"
_zshrc__test_and_alias clang clang $_zshrc__CCFLAGS $_zshrc__C99FLAGS $_zshrc__LLVMFLAGS
_zshrc__test_and_alias clang++ clang++ $_zshrc__CXXFLAGS $_zshrc__LLVMFLAGS $_zshrc__LLVMXXFLAGS

_zshrc__NVCC_CC_FLAGS="-Xcompiler -time,-Wcoverage-mismatch,-fopenmp"
_zshrc__NVCC_LD_FLAGS="-Xlinker $_zshrc__LINKERFLAGS"
_zshrc__NVCCFLAGS="$_zshrc__NVCC_CC_FLAGS $_zshrc__NVCC_LD_FLAGS -Xptxas -v"
_zshrc__test_and_alias nvcc nvcc $_zshrc__NVCC_BACKEND_CC_PATH $_zshrc__NVCCFLAGS

_zshrc__test_and_alias dmd dmd -w -wi

_zshrc__test_and_alias boost-formatter sed '"s/boost:://g;s/mpl_::bool_<\\(false\\|true\\)>/mpl::\\1_/g;s/\\(mpl_::na, \\)*mpl_::na//g;"'

_zshrc__test_and_alias vim vim -p

# network tools
_zshrc__test_and_alias ping ping -A
_zshrc__test_and_alias ping6 ping6 -A

_zshrc__test_and_alias traceroute traceroute -q 1 -A -e
_zshrc__test_and_alias traceroute6 traceroute6 -q 1 -A -e

_zshrc__test_and_alias scp scp -C

_zshrc__test_and_alias nslookup nslookup -type=ANY

_zshrc__test_and_alias unsafe-ssh ssh -o StrictHostKeyChecking=no

# load site specific aliases
[ -f ~/.zsh_aliases ] && . ~/.zsh_aliases

# load site specific rc
[ -f $HOME/.profile ] && . $HOME/.profile

function import-prefix
{
    [[ -d $1 ]] && . $HOME/.local/sbin/import-prefix.sh $1
}

import-prefix $HOME/.local

# テトリスをロード
autoload -U tetris
zle -N tetris

# {{{ 長門との会話
## see: http://d.hatena.ne.jp/khiker/20070805/zsh_nagato
zle -N nagato
function nagato
{
    emulate -L zsh
    if [ ! zle ]; then
        print -u2 "Use M-x nagato RET to watch nagato and kyon's chat."
        return 1
    fi
    clear
    nagato-main
}

function nagato-main
{
    # 長門有希のセリフ
    local nagato1="YUKI.N>見えてる？"
    local nagato2_1="YUKI.N>そっちの空間とは"
    local nagato2_2="まだ完全には連結を絶たれていない。"
    local nagato2_3="でも時間の問題。"
    local nagato2_4="そうなれば最後。"
    local nagato3_1="どうにもならない。"
    local nagato3_2="情報統合思念体は失望している。"
    local nagato3_3="これで進化の可能性は失われた。"
    local nagato4_1="涼宮ハルヒは"
    local nagato4_2="何もない所から"
    local nagato4_3="情報を生み出す力を"
    local nagato4_4="持っていた。"
    local nagato4_5="それは情報統合思念体にも"
    local nagato4_6="ない力。"
    local nagato4_7="この情報創造能力を解析すれば"
    local nagato4_8="自律進化への糸口が"
    local nagato4_9="つかめるかもしれないと考えた。"
    local nagato5_1="YUKI.N>あなたに賭ける。"
    local nagato6_1="もう一度こちら回帰することを"
    local nagato6_2="我々は望んでいる。"
    local nagato6_3="涼宮ハルヒは重要な観察対象。"
    local nagato6_4="わたしという個体も"
    local nagato6_5="あなたには戻ってきて欲しいと感じている。"
    local nagato7_1="YUKI.N>また図書館に"
    local nagato8_1="YUKI.N> sleeping beauty"
    # YUKI.N> が頭につかないものの頭に必要な空白
    local nagato_sp="       "
    # キョンのセリフ
    # nagato1  が終了後
    local kyon1="ああ"
    # nagato2_4 が終了後
    local kyon2="どうすりゃいい？"
    # nagato5_1 が終了後
    local kyon3="何をだよ"

    nagato_print()
    {
        local message=$1
        # set waiting time
        if [[ $message[0] == "Y" ]] then
            local time=0.1
        else
            local time=0.05
            printf $nagato_sp
        fi
        for (( count=1; count<=$#message; count+=1 ))
        do
            # print message
            printf $message[$count]
            sleep $time
            # After ">" is, Japanese. exception exist.
            if [[ $message[$count] == ">" ]] then
                if [[ $message[$count+1] != " " ]] then
                    local time=0.03
                fi
            fi
        done
        sleep 0.3
        # linefeed
        echo ''
    }

    kyon_print()
    {
        local message=$1
        local time=0.08
        sleep 0.5
        for (( count=1; count<=$#message; count+=1 ))
        do
            # print message
            printf $message[$count]
            sleep $time
        done
        sleep 0.5
        # linefeed
        echo ''
    }

    # 実際に実行. 力技. もっと上手くできたろうに・・・.
    # 画面を綺麗に.
    clear
    nagato_print $nagato1
    kyon_print $kyon1
    nagato_print $nagato2_1
    nagato_print $nagato2_2
    nagato_print $nagato2_3
    nagato_print $nagato2_4
    sleep 1.0
    clear
    kyon_print $kyon2
    sleep 1.0
    clear
    nagato_print $nagato3_1
    nagato_print $nagato3_2
    nagato_print $nagato3_3
    sleep 1.0
    clear
    nagato_print $nagato4_1
    nagato_print $nagato4_2
    nagato_print $nagato4_3
    nagato_print $nagato4_4
    sleep 0.8
    nagato_print $nagato4_5
    nagato_print $nagato4_6
    nagato_print $nagato4_7
    nagato_print $nagato4_8
    nagato_print $nagato4_9
    sleep 1.0
    clear
    nagato_print $nagato5_1
    sleep 1.0
    clear
    kyon_print $kyon3
    sleep 1.0
    clear
    nagato_print $nagato6_1
    nagato_print $nagato6_2
    nagato_print $nagato6_3
    sleep 0.8
    nagato_print $nagato6_4
    nagato_print $nagato6_5
    sleep 1.0
    clear
    nagato_print $nagato7_1
    sleep 2.0
    clear
    nagato_print $nagato8_1
}
# }}}

# vim: expandtab
