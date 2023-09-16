---
layout: default
published: true
title: Serial Number Calculator2
permalink: /calculator-iframe/
feature_image: serial
---


<div class="calculator">
	<label>Insert your SX70 Serial Number:</label>
	<input type="text" id="calculator-input" placeholder="0E504057143" value="0E504057143" />
	<button onclick="calculateSerialNumber()">Calculate</button>
</div>
<div class="calculator-footer">Powered by <a href="{{ site.url }}">OpenSX70</a></div>

<div class="calculator-results">
	<div class="calculator-row serial-number">
		<label>Serial Number : </label>
		<div class="serial-number-value">0E504057143</div>
	</div>
	<div class="calculator-row config">
		<label>Config : </label>
		<div class="config-value">0E504057143</div>
	</div>
	<div class="calculator-row model">
		<label>Model : </label>
		<div class="model-value">0E504057143</div>
	</div>
	<div class="calculator-row birthday">
		<label>Birthday : </label>
		<div class="birthday-value">0E504057143</div>
	</div>
	<div class="calculator-row birthday">
		<label>Camera Number : </label>
		<div class="camera-number-value">0E504057143</div>
	</div>
	<div class="calculator-row birthday">
		<label>Shift Number : </label>
		<div class="shift-number-value">0E504057143</div>
	</div>
</div>


<script src=' {{ "/js/calculator.js" | prepend: site.baseurl }}'></script>