# fzfでAWSプロファイルを切り替え
# Usage: awsp
awsp() {
    local selected_profile
    selected_profile=$(aws configure list-profiles |
        grep -v "default" |
        sort |
        fzf --prompt "AWS Profile > " \
            --height 50% --layout=reverse --border \
            --preview-window 'right:50%' \
            --preview "grep -A5 {} ~/.aws/config")

    # Ctrl-C or ESC: プロファイルを解除
    if [[ -z "$selected_profile" ]]; then
        echo "Unset AWS_PROFILE"
        unset AWS_PROFILE
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        return
    fi

    # プロファイルを設定
    export AWS_PROFILE="$selected_profile"
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    echo "AWS_PROFILE=$selected_profile"

    # SSO セッションの確認
    local check_sso=$(aws sts get-caller-identity 2>&1)

    if [[ "$check_sso" == *"expired"* || "$check_sso" == *"invalid"* ]]; then
        echo "\nSession expired. Logging in..."
        aws sso login
    else
        echo "$check_sso"
    fi
}
