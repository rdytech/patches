#!/bin/bash
set -e

echo '--- setting ruby version'
cd /var/lib/buildkite-agent/.rbenv/plugins/ruby-build && git pull && cd -
rbenv install 2.3.7 -s
rbenv local 2.3.7

echo '--- setting up env'
REVISION=https://github.com/$BUILDBOX_PROJECT_SLUG/commit/$BUILDBOX_COMMIT

echo '--- bundling'
bundle install -j $(nproc) --without production --quiet

echo '--- running specs'
if bundle exec rspec; then
  echo "[Successful] $BUILDBOX_PROJECT_SLUG - Build - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "green"
else
  echo "[Failed] Build $BUILDBOX_PROJECT_SLUG - Build - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "red"
  exit 1;
fi
