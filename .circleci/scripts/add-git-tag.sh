#!/bin/bash

BRANCH_NAME=$1

# MAJOR/MINOR/PATCH default=PATCH
UPDATE_VERSION=$2
${UPDATE_VERSION:='PATCH'}

echo "BRANCH_NAME: $BRANCH_NAME"
echo "UPDATE_VERSION: $UPDATE_VERSION"

# ブランチの最新のタグを取得
PREFIX="v"
APPENDIX=""
if [ $BRANCH_NAME != "master" ]; then
  APPENDIX="-$BRANCH_NAME"
fi

CURRENT_VERSION=`git tag -l --sort -refname | grep -m1 "$APPENDIX"`
if [ -z "$CURRENT_VERSION" ]; then
  CURRENT_VERSION=${PREFIX}1.0.0-${BRANCH_NAME}
fi
echo "current latest version tag: $CURRENT_VERSION"

REGEXP="s/${PREFIX}(.*)$APPENDIX/\1/"
CURRENT_VERSION_NUM=`echo $CURRENT_VERSION | sed -r $REGEXP`
echo "current latest version tag num: $CURRENT_VERSION_NUM"

# 該当バージョンのアップデート
VERSION_BITS=(${CURRENT_VERSION_NUM//./ })
V_MAJOR=${VERSION_BITS[0]}
V_MINOR=${VERSION_BITS[1]}
V_PATCH=${VERSION_BITS[2]}

if [ $$UPDATE_VERSION == "MAJOR" ]; then
    V_MAJOR=$((V_MAJOR+1))
elif [ $$UPDATE_VERSION == "MINOR" ]; then
    V_MINOR=$((V_MINOR+1))
else
    V_PATCH=$((V_MINOR+1))
fi

NEW_VERSION_NUM="$V_MAJOR.$V_MINOR.$V_PATCH"
NEW_TAG="$PREFIX$NEW_VERSION_NUM$BRANCH_NAME"
echo "new latest version tag: $NEW_TAG"

git config user.email "80236749+cc-sato@users.noreply.github.com"
git config user.name "cc-sato"
git tag $NEW_TAG
git push origin $NEW_TAG


