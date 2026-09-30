#!/usr/bin/sh

set -x

echo hi

git for-each-ref --shell --format='
    REFNAME_THINGY=%(refname);
    REFNAME_BUT_LIKE_USABLE="${REFNAME_THINGY/refs\/heads\//}";

    echo $REFNAME_THINGY;

    echo "printing usable refname thingy";
    echo $REFNAME_BUT_LIKE_USABLE;
    echo "^^^thingy";

    if !((echo $REFNAME_THINGY) | grep -q "refs/heads/main"); then
        git checkout $REFNAME_BUT_LIKE_USABLE;
        git cherry-pick $(git log -n 1 | grep commit | sed 's/commit//g')..main;
        git cherry-pick --continue;
        echo;
        echo "printing branch";
        git rev-parse --abbrev-ref HEAD;
        echo "^^thats the branch"
    else
        echo "skipping main branch";
    fi;

    echo;
    echo;
    echo;
' refs/heads/ | sh

git checkout main;

echo bye
