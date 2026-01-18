# giboを使って.gitignoreを生成
# Usage: gi [output_file]
# Example: gi .gitignore
gi() {
    local input_file="$1"

    # デフォルトは .gitignore
    if [[ -z "$input_file" ]]; then
        input_file=".gitignore"
    fi

    # fzfでテンプレートを選択
    local selected=$(gibo list | fzf \
        --multi \
        --preview "gibo dump {} | bat --style=numbers --color=always --paging=never")

    # 選択がなければ終了
    if [[ -z "$selected" ]]; then
        echo "No templates selected. Exiting."
        return
    fi

    # 選択したテンプレートをファイルに追加
    echo "$selected" | xargs gibo dump >> "$input_file"

    # 結果をbatで表示
    bat "$input_file"
}
