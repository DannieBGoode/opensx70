# Changelog

All notable changes to openSX70 are documented here.

## [0.0.1.0] - 2026-10-01

### Added

- Responsive Netlify Image CDN delivery for local JPEG photos and lossless PNG assets, including responsive product-gallery navigation.
- A production media-budget check that rejects inline image payloads and public raster assets over 25 MB.

### Changed

- New and existing blog/product images now use browser-selected CDN derivatives, lazy loading, and seven-day image caching while preserving a quality-95 JPEG fallback.
- The two posts that contained multi-megabyte inline images now reference regular image files, and feed descriptions are kept compact.
