# openSX70

A photography-focused website for the openSX70 project, built with **Jekyll** on top of a template-based theme and deployed on **Netlify**.

## Tech stack

- **Static site generator:** Jekyll
- **Templating/layouts:** Jekyll layouts/includes and Sass assets
- **CMS:** Netlify CMS (`/admin`)
- **Authentication for CMS:** Netlify Identity + Netlify Git Gateway
- **Hosting/builds:** Netlify
- **Tests/CI:** Minitest, run by GitHub Actions (`.github/workflows/test.yml`)

## Repository structure (high level)

- `_posts/` – blog posts
- `_tutorials/` – tutorial collection content
- `_pages/` – custom pages
- `_layouts/`, `_includes/`, `_sass/` – template/theme structure
- `_plugins/` – custom Liquid filters and build hooks (image delivery, preview truncation)
- `test/` – Minitest suite (see `TESTING.md`)
- `admin/` – Netlify CMS app and CMS configuration
- `_site/` – generated output (build artifact)

## Prerequisites

- Ruby (recommended Ruby 3.x or 4.x; CI tests Ruby 3.4 and 4.0)
- Bundler

Install dependencies:

```bash
bundle install
```

## Local development

Run the local Jekyll server:

```bash
bundle exec jekyll serve
```

Then open:

- Website: `http://localhost:4000`
- CMS (when serving locally): `http://localhost:4000/admin/`

Run the test suite (it builds the site once and checks the rendered pages):

```bash
bundle exec rake test
```

See `TESTING.md` for how the tests are organized.

## Production build

Netlify uses the following build command:

```bash
ruby scripts/check_media_budget.rb && bundle exec jekyll build
```

This generates the static site into the `_site/` folder, which is the deploy output published by Netlify. Netlify sets `BUNDLE_WITHOUT=test`, so the test-only gems (`minitest`, `rake`) are not installed for production builds.

The media check rejects inline image data and public image files larger than 25 MB. It reports larger photographic assets over 5 MB for review without changing their pixels.

In Netlify production builds, `_plugins/image_filters.rb` adds responsive `srcset` variants for raster images under `/img/` and `/assets/uploads/`. JPEGs use Netlify Image CDN WebP transformations at quality 95, with a 2400px quality-95 JPEG fallback for older clients and non-negotiating URLs; PNGs remain lossless PNG transformations. Variants step from 320 to 4800 pixels wide, stop below the source file's own width and always end with the full-size source, so no variant claims more pixels than the original has. The plugin reads each local image's size from its file header (`_plugins/image_dimensions.rb`, honoring EXIF orientation) and adds that width to images that do not set their own size; if a size cannot be read, the build logs an `Image CDN:` warning and offers the full width ladder. Unsupported formats and external images retain their original URL. Product-gallery navigation updates the same CDN derivatives instead of fetching the source JPEG again. Images embedded in blog, page, tutorial, and product content use this policy automatically after deployment. Image responses are browser-cached for seven days; filenames should be changed when replacing an image so visitors do not retain an old version during that window. `/css/*`, `/fonts/*` and `/js/vendor/*` get the same seven-day cache in `netlify.toml`; `main.css` carries a per-build query string so deploys still reach visitors, and `main.js` and `calculator.js` keep Netlify's default revalidation.

Each image's `sizes` hint follows its measured display width, so the browser picks the smallest variant that still covers the displayed pixels. Layouts pass a preset to the `image_sizes` filter (`content` for post and page bodies, `post-preview`, `author-preview`, `author-bio`; an unknown name fails the build). Images with known classes or ids (product gallery, shop cards, related-post thumbnails, avatars) use their own hint, which is widened by the photo's aspect ratio when the box crops it with `object-fit: cover`. Other images fall back to `(max-width: 768px) 100vw, 1200px`. Tags that already have a `srcset` are left alone, and an author-written `sizes` is kept.

The `lazy_images` filter keeps the first image on a page eager and adds `loading="lazy"` to later images and to all embedded iframes (videos). Listing pages (home, category, author, alternate home) show HTML post previews via the `truncate_html_words` filter; only the first preview that contains an image loads it eagerly.

## CMS and authentication

This project uses **Netlify CMS** for content editing.

- CMS entrypoint: `admin/index.html`
- CMS configuration: `admin/config.yml`
- Backend: `git-gateway` (configured in `admin/config.yml`)
- Login/authentication: **Netlify Identity** (identity widget loaded in `admin/index.html`)

### Typical CMS workflow

1. Sign in at `/admin` using Netlify Identity.
2. Create or edit content in configured collections (Blog, Tutorials, Pages).
3. Save and publish changes through Netlify CMS.
4. Netlify rebuilds and deploys the updated `_site` output.

## Notes

- Site-wide configuration lives in `_config.yml`.
- Pagination is enabled via `jekyll-paginate`.
- Uploaded media for CMS is configured under `assets/uploads` (with collection-specific media settings for blog images).
