---
layout: page
title: Shop
permalink: /shop
feature_image: SX70_images/openSX70-cameraporn-6
---

Browse the current openSX70 hardware catalog. Each product page includes pricing, compatibility variants, and technical context for your build planning.

<div class="shop-grid">
  {% assign sorted_products = site.products | sort: "title" %}
  {% for product in sorted_products %}
  <article class="shop-card">
    <a class="shop-card-media" href="{{ product.url | relative_url }}" aria-label="View {{ product.title }}">
      <img src="{{ product.image | relative_url }}" alt="{{ product.title }} placeholder image">
    </a>
    <div class="shop-card-content">
      <h2><a href="{{ product.url | relative_url }}">{{ product.title }}</a></h2>
      <p class="shop-card-price">{{ product.currency }} {{ product.price }}</p>
      <p class="shop-card-description">{{ product.short_description | default: product.description }}</p>
      <a class="shop-card-link" href="{{ product.url | relative_url }}">View product details</a>
    </div>
  </article>
  {% endfor %}
</div>
