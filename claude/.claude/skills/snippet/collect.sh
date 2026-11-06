#!/usr/bin/env bash
# Prints the last complete snippet interval (boundaries are Wednesday and Friday at 20:00, local time)
# and every commit authored in it, per repository under $HOME.
set -euo pipefail

export LC_TIME=C

leeway=$((4 * 3600))
large_repo_author_count=5
# Matched against "name <email>"; `git config user.*` is empty inside the sandbox.
my_author_patterns=("Aida van de Wetering" "Aidavdw")

# Latest Wednesday or Friday 20:00 at or before the given epoch.
latest_boundary_at_or_before() {
    local t=$1 back day boundary
    for back in {0..7}; do
        day=$(date -d "$(date -d "@$t" +%F) -$back days" +%F)
        case $(date -d "$day" +%u) in
            3 | 5) ;;
            *) continue ;;
        esac
        boundary=$(date -d "$day 20:00" +%s)
        if ((boundary <= t)); then
            echo "$boundary"
            return
        fi
    done
}

now=${SNIPPET_NOW:-$(date +%s)}
end=$(latest_boundary_at_or_before $((now + leeway)))
start=$(latest_boundary_at_or_before $((end - 1)))

echo "INTERVAL: $(date -d "@$start" '+%a %-d %b %Y %H:%M') – $(date -d "@$end" '+%a %-d %b %Y %H:%M')"
echo "START: $(date -d "@$start" --iso-8601=seconds)"
echo "END: $(date -d "@$end" --iso-8601=seconds)"
echo

find "$HOME" -maxdepth 4 \
    \( -name .cache -o -name .cargo -o -name .rustup -o -name .local -o -name node_modules -o -name target \) -prune \
    -o -name .git -print 2>/dev/null |
    while read -r git_path; do
        repo=$(dirname "$git_path")
        common_dir=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || continue
        echo "$common_dir"$'\t'"$repo"
    done |
    sort -u -k1,1 |
    while IFS=$'\t' read -r _ repo; do
        author_count=$(git -C "$repo" log --all --format=%ae | sort -u | wc -l)
        is_large=$((author_count > large_repo_author_count))

        # In large shared repositories, only the user's own commits count.
        author_args=()
        if ((is_large)); then
            for pattern in "${my_author_patterns[@]}"; do
                author_args+=(--author="$pattern")
            done
        fi

        # `--since` filters on committer date, which is normally not before the author date,
        # so it is a superset of the author-date filter below.
        # Deduplicating on author date and subject drops rebased copies on other branches.
        commits=$(
            git -C "$repo" log --all --since="@$start" "${author_args[@]}" --format='%at%x09%h%x09%an%x09%s' |
                awk -F'\t' -v start="$start" -v end="$end" '$1 >= start && $1 < end && !seen[$1 FS $4]++' |
                sort -n
        )
        [[ -z $commits ]] && continue

        echo "## $repo ($author_count authors in history$( ((is_large)) && echo ', only your commits'))"
        while IFS=$'\t' read -r at hash author subject; do
            stat=$(git -C "$repo" show --shortstat --format= "$hash" | sed 's/^ *//')
            echo "$hash $(date -d "@$at" '+%a %H:%M') [$author] $subject ($stat)"
        done <<<"$commits"
        echo
    done
