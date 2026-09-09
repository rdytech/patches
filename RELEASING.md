# Releasing patches

Publishing is only ever done by GitHub Actions (`.github/workflows/release.yml`), triggered by
a `vX.Y.Z` tag whose commit is reachable from `develop`. Tags on any other branch are rejected by
the workflow before anything is built. No one needs local publishing credentials — the workflow
authenticates to RubyGems.org via OIDC trusted publishing.

The `v` prefix is required: the workflow triggers on `v*`, and it is the tag `rake release`
creates. RubyGems.org strips it, so `v3.6.3` publishes version `3.6.3` — which is why the
versions listed on rubygems.org never carry the prefix.

## Cutting a release

1. Bump `MAJOR` / `MINOR` / `PATCH` in `lib/patches/version.rb`.
2. Add a new `## [X.Y.Z] - YYYY-MM-DD` entry to the top of `CHANGELOG.md` describing the changes.
3. Commit both changes and get them onto `develop` (PR + merge, as normal).
4. From an up-to-date `develop`, tag the commit and push the tag:

   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

5. Watch the "Release" workflow run in the Actions tab.
6. Confirm the new version shows up on [rubygems.org](https://rubygems.org/gems/patches).

Do **not** run `bundle exec rake release` from a workstation. It would push the gem under your own
credentials *and* push the tag, and the workflow's own `rake release` would then fail because the
version already exists.

## One-time setup

- **RubyGems.org**: an existing owner of the `patches` gem must add a Trusted Publisher for
  `rdytech/patches`, workflow `release.yml` (no environment). See
  [Trusted Publishing: adding a publisher](https://guides.rubygems.org/trusted-publishing/adding-a-publisher/).
  Until this is done, the release will fail while configuring credentials. The gem currently lists
  a single owner, handle `jr`.
- **GitHub Packages**: the workflow carries a `packages: write` permission, inherited from the
  shared workflow, but no step publishes there and nothing is pushed to it.
