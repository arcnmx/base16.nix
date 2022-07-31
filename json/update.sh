set -eu

MAINDIR=$CHECKOUT/out

main() {
	CI_UPDATE=
	if [[ ${CI_PLATFORM-} = gh-actions ]] && [[ ${GITHUB_REF-} = refs/heads/generate || ${GITHUB_EVENT_NAME-} = schedule ]]; then
		CI_UPDATE=1
	fi

	if [[ ! -d $MAINDIR ]]; then
		git worktree add $MAINDIR main
	fi

	nix flake lock --update-input base16-schemes
	LOCK_CHANGES="$(git status --porcelain flake.lock)"
	if [[ -n $LOCK_CHANGES ]]; then
		git add flake.lock
		nix flake check
		git commit -m "flake update"
		if [[ -n $CI_UPDATE ]]; then
			git push origin generate
		fi
	fi

	nix build -L $CHECKOUT#base16-schemes-json
	rm -rf $MAINDIR/schemes
	mkdir -p $MAINDIR/schemes
	cp result/* $MAINDIR/schemes/
	rm -f result

	SCHEME_CHANGES="$(git-out status --porcelain)"
	if [[ -n $SCHEME_CHANGES ]]; then
		git-out add schemes
		nix flake check $MAINDIR
		git-out commit -m "scheme update at $(git rev-parse HEAD)"
		if [[ -n $CI_UPDATE ]]; then
			git-out push origin generate
		fi
	fi
}

export GIT_{COMMITTER,AUTHOR}_EMAIL=ghost@konpaku.2hu
export GIT_{COMMITTER,AUTHOR}_NAME=ghost

git() {
	command git -C $CHECKOUT "$@"
}

git-out() {
	command git -C $MAINDIR "$@"
}

main "$@"
