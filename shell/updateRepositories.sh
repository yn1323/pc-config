# 対象のディレクトリ
cd ~/work

for dir in */ ; do
    if [[ -d "$dir/.git" ]]; then
        cd "$dir"

        # 現在のブランチ名を取得
        current_branch=$(git rev-parse --abbrev-ref HEAD)
        
        # Git 差分があれば stash
        if [[ -n $(git status -s) ]]; then
            stash_name="stash-$(date +%Y-%m-%d)"
            git stash save "$stash_name"
        fi
        
        # main ブランチに切り替えて pull
        git checkout main
        git pull origin main
        
        # 元のブランチに戻る
        git checkout "$current_branch"
        
        # Stashがあれば適用
        if git stash list | grep -q "$stash_name"; then
            git stash pop
        fi
        
        cd ..
    fi
done