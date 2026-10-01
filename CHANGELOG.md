# Changelog

All notable changes to openSX70 are documented here.

## [0.0.5.0] - 2026-10-02

### Changed

- Photos download at the size they are shown. On phones, homepage previews now fetch a file about half as large, and desktops no longer download photos twice as wide as the column. Every photo still gets at least as many pixels as the screen shows, at the same quality.
- Author avatars load small versions from the image service instead of the full-size original.
- Small photos display at their own size again instead of shrinking inside their column.
- Repeat visits reuse the site's fonts, styles and vendor scripts for a week instead of re-checking them on every page.

### Fixed

- Tutorial cards, related-post thumbnails, shop cards and product thumbnails are sharp again; some of them were loading files smaller than the space they fill.
- Wide photos cropped into square or fixed-height cards download enough detail to stay sharp.
- Very large photos can be shown at their full resolution on big, high-density screens.
- Avatars keep their proportions instead of being squashed, and the author page shows a round avatar while bio photos keep their shape.
- A single product in the shop gets an image sharp enough for its full-width card.
- Unusual or damaged image files and image paths no longer slow down or break the site build.

## [0.0.4.0] - 2026-10-01

### Changed

- Pages show their header photo sooner: the browser now fetches it first instead of waiting for the stylesheet. Same image, same quality.
- Text no longer waits for the icon font to download.

### Fixed

- The "read another" cards at the bottom of posts show each post's photo again, instead of collapsing and letting their titles overlap the author details.
- Related-post thumbnails stay sharp on tablets and phones.
- Posts created in the CMS no longer print their header image path as stray text at the bottom of the page.
- Homepage post cards are one working link again; links inside a post no longer break the card into an empty, unclickable link.
- Posts without a category no longer show an empty category link.

### Removed

- The retired Google Universal Analytics tag, which had stopped recording data in 2023 but still loaded on every page.

## [0.0.3.0] - 2026-10-01

### Fixed

- Post previews on the homepage, category, author and alternate home pages show their photos and paragraph formatting again, instead of a run of plain text.
- Long image captions no longer cut a preview image in half, and previews stop cleanly at the word limit instead of pulling in the images that follow it.
- Video embeds in previews fit the column on small screens.

### Changed

- Only the first preview image on a listing page loads right away; later preview images load as you scroll, at full quality.
- Video and document embeds load as you scroll on every page, including full posts.

### Added

- An automated test suite (`bundle exec rake test`) that runs on every pull request, covering the preview filter and the rendered listing pages.

## [0.0.2.0] - 2026-10-01

### Fixed

- Keep direct JPEG image URLs and gallery fallbacks compatible with browsers that do not negotiate WebP.
- Apply the media budget, responsive transformations, and cache policy to future CMS uploads under `assets/uploads`.

## [0.0.1.0] - 2026-10-01

### Added

- Responsive Netlify Image CDN delivery for local JPEG photos and lossless PNG assets, including responsive product-gallery navigation.
- A production media-budget check that rejects inline image payloads and public raster assets over 25 MB.

### Changed

- New and existing blog/product images now use browser-selected CDN derivatives, lazy loading, and seven-day image caching while preserving a quality-95 JPEG fallback.
- The two posts that contained multi-megabyte inline images now reference regular image files, and feed descriptions are kept compact.
