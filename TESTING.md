# Testing

Tests are what let us change templates and plugins with confidence: when a fix lands, a test should keep it fixed.

## Running

```bash
bundle install
bundle exec rake test
```

GitHub Actions runs the same command, plus `ruby scripts/check_media_budget.rb`, on Ruby 3.4 and 4.0 for pushes to `master` and every pull request (`.github/workflows/test.yml`).

## Framework

[Minitest](https://github.com/minitest/minitest) via `Rake::TestTask`. Tests live in `test/` and are named `*_test.rb`. `test/`, `Rakefile`, `CLAUDE.md` and `TESTING.md` are excluded from the Jekyll build (`exclude:` in `_config.yml`).

## Layers

- **Unit tests** cover Liquid filters and helpers in `_plugins/` by including the module and calling the filter directly (see `test/html_truncate_test.rb`).
- **Rendered-site tests** build the whole site once per run with `built_site` from `test/test_helper.rb`, using the production image CDN setting, and assert on the generated HTML (see `test/homepage_test.rb`). Use these for layout and template regressions.

## Conventions

- One test class per file, named after the unit under test.
- Assert on concrete output: exact strings for filters, specific markup and asset paths for rendered pages.
- When fixing a bug, add a test that fails without the fix.
