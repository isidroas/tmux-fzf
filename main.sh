#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -z "$TMUX_FZF_ORDER" ]] && TMUX_FZF_ORDER="copy-mode|session|window|pane|command|keybinding|clipboard|process"
source "$CURRENT_DIR/scripts/.envs"

items_origin2="$(echo $TMUX_FZF_ORDER | tr '|' '\n')"

# remove copy-mode from options if we aren't in copy-mode
if [ "$(tmux display-message -p '#{pane_in_mode}')" -eq 0 ]; then
    items_origin="$(sed '/copy-mode/d'<<<${items_origin2})" # Esto soluciona el bug de que copy-mode esté en medio y elimine un '|' de más
fi


if [[ ! -z "$TMUX_FZF_MENU" ]]; then
    items_origin+=$'\nmenu'
fi


item=$($TMUX_FZF_BIN $TMUX_FZF_OPTIONS <<< ${items_origin}$'\n[cancel]')
[[ "$item" == "[cancel]" || -z "$item" ]] && exit
tmux run-shell -b "$CURRENT_DIR/scripts/${item}.sh"
