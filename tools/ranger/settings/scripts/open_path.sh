#!/usr/bin/env bash
# shellcheck disable=all

readonly file_path="$1"

readonly OPEN_IMAGE="feh -x"
readonly OPEN_VIDEO="vlc"
readonly OPEN_AUDIO="cplayer"
readonly OPEN_FILE="vim"
readonly OPTIONS_IDES=( "nvim" "code" "ranger" "cplayer" )

function choice_ide {
    local options=($@)

    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=4
    BACKTITLE="Choice an option"
    TITLE="Applications"
    MENU="Choose one of the following options:"

    menu_options=()
    for ((idx=0; idx<${#options[@]}; ++idx)); do
        menu_options+=( "$idx" )
        menu_options+=( "${options[idx]}" )
    done

    CHOICE=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${menu_options[@]}" \
                    2>&1 >/dev/tty)
    local status=$?
    if (( $status != 0 )); then
        CHOICE=-1
    fi

    return $CHOICE
}

if [[ -n "${file_path}" ]]; then
    if [[ -f "${file_path}" ]]; then
        if file "${file_path}" | grep -qE 'image|bitmap'; then
            ${OPEN_IMAGE} "${file_path}"
        elif file "${file_path}" | grep -qE 'mkv|mp4'; then
            { nohup ${OPEN_VIDEO} "${file_path}" >/dev/null 2>&1 & } &
        elif file "${file_path}" | grep -qE 'Audio'; then
            { nohup alacritty -e bash -c "${OPEN_AUDIO} \"${file_path}\"" >/dev/null 2>&1 & } &
        else
            ${OPEN_FILE} "${file_path}"
        fi
    else
        choice_ide ${OPTIONS_IDES[@]}
        choice=${OPTIONS_IDES[$?]}

        case "${choice}" in
            "")
                ;;
            nvim | cplayer)
                if pgrep -x "tmux" > /dev/null; then
                    { nohup alacritty -e bash -c "cd \"${file_path}\" && tmux new-session ${choice} ." >/dev/null 2>&1 & } &
                else
                    session_id=$(tmux ls | grep attached | head -1 | cut -d ':' -f 1)
                    if [[ "${choice}" == "cplayer" ]]; then
                        { nohup alacritty -e bash -c "cd \"${file_path}\" && tmux new-window -t ${session_id} cplayer -p ." >/dev/null 2>&1 & } &
                    else
                        { nohup alacritty -e bash -c "cd \"${file_path}\" && tmux new-window -t ${session_id} ${choice} ." >/dev/null 2>&1 & } &
                    fi
                fi
                ;;
            *)
                cd "${file_path}"
                VISUAL=vim EDITOR=vim $choice .
                ;;
        esac
    fi
fi
