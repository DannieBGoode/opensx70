# openSX70 website

Jekyll site deployed on Netlify. See README.md for local development and the production build.

## Testing

- Run `bundle exec rake test` (tests live in `test/`). See TESTING.md.
- New filters or plugins in `_plugins/` get a unit test; layout/template changes get a rendered-site assertion in a `test/*_test.rb` file.
- Bug fixes include a regression test that fails without the fix.
- Never commit code that makes existing tests fail.
