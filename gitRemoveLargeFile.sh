git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}'
git rev-list --objects --all | grep 1abdfasd
