# openSX70

A photography-focused website for the openSX70 project, built with **Jekyll** on top of a template-based theme and deployed on **Netlify**.

## Tech stack

- **Static site generator:** Jekyll
- **Templating/layouts:** Jekyll layouts/includes and Sass assets
- **CMS:** Netlify CMS (`/admin`)
- **Authentication for CMS:** Netlify Identity + Netlify Git Gateway
- **Hosting/CI:** Netlify

## Repository structure (high level)

- `_posts/` – blog posts
- `_tutorials/` – tutorial collection content
- `_pages/` – custom pages
- `_layouts/`, `_includes/`, `_sass/` – template/theme structure
- `admin/` – Netlify CMS app and CMS configuration
- `_site/` – generated output (build artifact)

## Prerequisites

- Ruby (recommended Ruby 3.x)
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

## Production build

Netlify uses the following build command:

```bash
ruby scripts/check_media_budget.rb && bundle exec jekyll build
```

This generates the static site into the `_site/` folder, which is the deploy output published by Netlify.

The media check rejects inline image data and public image files larger than 25 MB. It reports larger photographic assets over 5 MB for review without changing their pixels.

In Netlify production builds, `_plugins/image_filters.rb` adds responsive `srcset` variants for raster images under `/img/` and `/assets/uploads/`. JPEGs use Netlify Image CDN WebP transformations at quality 95, with a 2400px quality-95 JPEG fallback for older clients and non-negotiating URLs; PNGs remain lossless PNG transformations. Variants are requested at 320, 800, 1600, 2400, and 3200 pixels, allowing cards and product thumbnails to avoid downloading a desktop-sized image. Unsupported formats and external images retain their original URL. Product-gallery navigation updates the same CDN derivatives instead of fetching the source JPEG again. Images embedded in blog, page, tutorial, and product content use this policy automatically after deployment. Image responses are browser-cached for seven days; filenames should be changed when replacing an image so visitors do not retain an old version during that window.

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
