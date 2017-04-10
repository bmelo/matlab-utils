#!/usr/bin/env bash

# always immediately exit upon error
set -e

# start in project root
cd "`dirname $0`/.."

./bin/require-clean-working-tree.sh
git reset HEAD --hard

read -p "Enter the version you want to publish, with no 'v' (for example '1.0.1'): " version
if [[ ! "$version" ]]
then
	echo "Aborting."
	exit 1
fi

# push the current branch (assumes tracking is set up) and the tag
git push
git push origin "$version"

success=0

# save reference to current branch
current_branch=$(git symbolic-ref --quiet --short HEAD)

# temporarily checkout the tag's commit, publish to BOWER
bower unregister matlab-utils
bower register matlab-utils https://github.com/bmelo/matlab-utils.git


echo "Success."
