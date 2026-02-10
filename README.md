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
bundle exec jekyll build
```

This generates the static site into the `_site/` folder, which is the deploy output published by Netlify.

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
