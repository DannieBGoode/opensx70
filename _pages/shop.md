---
layout: page
title: Shop
permalink: /shop
feature_image: SX70_images/openSX70-cameraporn-6
---

<div class="shop-intro">
  <p class="shop-kicker">openSX70 Hardware Catalog</p>
  <p class="shop-lead">Browse replacement boards and modules for your camera build. Each product page includes pricing, compatibility variants, and visual references.</p>
</div>

<div class="shop-grid">
  {% assign sorted_products = site.products | sort: "title" %}
  {% for product in sorted_products %}
  {% assign first_gallery_image = product.images | first %}
  {% if first_gallery_image.image %}
  {% assign product_main_image = first_gallery_image.image %}
  {% else %}
  {% assign product_main_image = first_gallery_image | default: product.image %}
  {% endif %}
  <article class="shop-card">
    <a class="shop-card-media" href="{{ product.url | relative_url }}" aria-label="View {{ product.title }}">
      <img src="{{ product_main_image | relative_url }}" alt="{{ product.title }} main product image">
    </a>
    <div class="shop-card-content">
      <h2><a href="{{ product.url | relative_url }}">{{ product.title }}</a></h2>
      <p class="shop-card-price">{{ product.currency }} {{ product.price }}</p>
      <p class="shop-card-description">{{ product.short_description | default: product.description }}</p>
      <a class="shop-card-link" href="{{ product.url | relative_url }}">View details</a>
    </div>
  </article>
  {% endfor %}
</div>
