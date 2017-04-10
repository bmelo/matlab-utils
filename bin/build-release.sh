#!/usr/bin/env bash

# start in project root
cd "`dirname $0`/.."

./bin/require-clean-working-tree.sh

#read -p "Have you already updated the changelog? (y/N): " updated_changelog
#if [[ "$updated_changelog" != "y" ]]
#then
#	echo "Go do that!"
#	exit 1
#fi

read -p "Enter the new version number with no 'v' (for example '1.0.1'): " version
if [[ ! "$version" ]]
then
	echo "Aborting."
	exit 1
fi

success=0

# save reference to current branch
current_branch=$(git symbolic-ref --quiet --short HEAD)

# make a tagged detached commit of the dist files.
# no-verify avoids commit hooks.
if {
    git checkout --quiet --detach &&
    git reset -- * .gitignore &&
    git rm -r --cached * .gitignore &&
    git add -f *.m bower.json LICENSE &&
    git add -f components/* wrappers/* &&
    git commit --quiet --no-verify -e -m "version $version" &&
    git tag -a "$version" -m "version v$version"
}
then
    success=1
fi

# return to branch
git checkout -f --quiet "$current_branch"

if [[ "$success" == "1" ]]
then
	# keep newly generated files around
	git checkout --quiet "$version" -- dist
	git reset --quiet -- dist

	echo "Success."
else
	# unstage all files changes
	git reset --quiet

	# discard changes from version bump
	git checkout --quiet -- *.m

	echo "Failure."
	exit 1
fi
