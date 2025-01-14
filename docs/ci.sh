#!/usr/bin/env bash

set -o errexit
set -o pipefail
# set -o xtrace

# This script gets run from CI to render and upload docs for the main branch.

./build.py

# Only upload if we have defined credentials - we only have these defined for
# trusted commits (i.e. not PRs).
if [[ -n "${AWS_ACCESS_KEY_ID}" && $GITHUB_REF == "refs/heads/main" ]]; then
    aws s3 sync --delete --acl public-read ./public s3://docs.mitmproxy.org/dev
    aws cloudfront create-invalidation --distribution-id E1TH3USJHFQZ5Q \
        --paths "/dev/*"
fi
