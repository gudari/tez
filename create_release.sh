
#!/bin/bash

GITHUB_ORGANIZATION=$1
GITHUB_REPO=$2
HADOOP_VERSION=$3
VERSION=$4
GITHUB_TOKEN=$5

RELEASE_NAME="release-${VERSION}-hadoop-$HADOOP_VERSION-arm64"

release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_NAME\", \"target_commitish\": \"$RELEASE_NAME\", \"name\": \"$RELEASE_NAME\", \"draft\": false }" \
    https://api.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    -H "Content-Type:application/octet-stream" \
    --data-binary @tez-dist/target/tez-$VERSION-minimal.tar.gz https://uploads.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=tez-$VERSION-minimal.tar.gz

curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    -H "Content-Type:application/octet-stream" \
    --data-binary @tez-dist/target/tez-$VERSION.tar.gz https://uploads.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=tez-$VERSION.tar.gz
