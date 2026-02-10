---
layout: page
title: Shop
permalink: /shop
feature_image: SX70_images/openSX70-cameraporn-6
---

Browse our current openSX70 products. Click a product to view detailed specs, compatible camera variants, and pricing.

<div class="shop-grid">
  {% assign sorted_products = site.products | sort: "title" %}
  {% for product in sorted_products %}
  <article class="shop-card">
    <h2><a href="{{ product.url | relative_url }}">{{ product.title }}</a></h2>
    <p class="shop-card-price">{{ product.price }} {{ product.currency }}</p>
    <p>{{ product.short_description | default: product.description }}</p>
    <a class="shop-card-link" href="{{ product.url | relative_url }}">View product details</a>
  </article>
  {% endfor %}
</div>
