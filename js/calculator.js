function calculateSerialNumber() {

	document.querySelector(".calculator-results").style.display = "none";
	document.querySelector(".calculator input").classList.remove("error")
	let error = false;

	let serialNumber = document.querySelector("#calculator-input").value;

	if (serialNumber.length === 10) {
		serialNumber = "Z" + serialNumber;
	}

	if (((serialNumber[9] >= "A") && (serialNumber[9] <= "Z")) && ((serialNumber[10] >= "A") && (serialNumber[10] <= "Z"))) {
		let x = 4;
		serialNumber = [serialNumber.slice(0,4), "00", serialNumber.slice(x)].join('');
	}

	let configNumber = serialNumber[0];
	let MonthNumber = serialNumber[1];
	let ModelNumber = serialNumber[3];
	let CameraNumber = serialNumber.substring(4, 9);
	let ShiftNumber = serialNumber.substring(9, 11);

	let configurationBase =  {
		"": "nothing - Non-Hybrid",
		"X": "Unknown, probably a TI Ceramic",
		"Z": "Unknown",
		"F": "Fairchild	",
		"0": "hybrid \"Q\" shutter",
		"1": "delta hybrid",
		"2": "6th flash inhibit	",
		"3": "Alpha 2 electronics - Alpha production focus wheel",
		"4": "Alpha 2 electronics - Hybrid focus wheel",
		"5": "Alpha 2 electronics - Alpha \"K\" focus wheel",
		"6": "Alpha 2 electronics - ABS plated moldings",
		"7": "SLR680",
		"8": "SLR680"
	}
	let MonthBase = {
		"A": "January",
		"B": "February",
		"C": "March",
		"D": "April",
		"E": "May",
		"F": "June",
		"G": "July",
		"H": "August",
		"J": "September",
		"K": "October",
		"L": "November",
		"M": "December"
	}
	let YearBase = {
		"2": "1972",
		"3": "1973",
		"4": "1974",
		"5": "1975",
		"6": "1976",
		"7": "1977",
		"8": "1978",
		"9": "1979",
		"0": "1980",
		"1": "1981",
		"x2": "1982", // If configuration number > 4
		"x3": "1983", // If configuration number > 4
		"x4": "1984", // If configuration number > 4
		"x5": "1985", // If configuration number > 4
		"x6": "1986"  // If configuration number > 4
	}
	let ModelBase = {
		"0": "Model 1 or Alpha 1 Plated",
		"1": "Model 1 or Alpha 1",
		"2": "Model 2, SE, Sears, Alpha 2 unPlated",
		"3": "Model 3",
		"4": "Sonar",
		"6": "SLR680"
	}
	let configuration = configurationBase[configNumber];
	let Month = MonthBase[MonthNumber];
	let YearNumber = serialNumber[2];

	// if config > 4 then camera is from the 80s

	if ((parseInt(configNumber) > 4) && (parseInt(configNumber) <= 99) && (parseInt(YearNumber) >= 2) && (parseInt(YearNumber) <= 6) ) {
		YearNumber = "x" + serialNumber[2];
	}

	let Year = YearBase[YearNumber];
	let Model = ModelBase[ModelNumber];

	

	if ((configuration === undefined) || (Month === undefined) || (Year === undefined) || (Model === undefined)) {
		error = true;
	}

	let Day,
		Shift;
	if (parseInt(ShiftNumber) % 3 === 0) {
		Day = parseInt(ShiftNumber) / 3;
		Shift = "C";
	} else if ((parseInt(ShiftNumber) + 1) % 3 === 0) {
		Day = (parseInt(ShiftNumber) + 1) / 3;
		Shift = "B";
	} else if ((parseInt(ShiftNumber) + 2) % 3 === 0) {
		Day = (parseInt(ShiftNumber) + 2) / 3;
		Shift = "A";
	} else {
		error = true;
	}

	document.querySelector(".serial-number-value").textContent = document.querySelector("#calculator-input").value;
	document.querySelector(".config-value").textContent = configuration;
	document.querySelector(".birthday-value").textContent = Month + " " + Day + ", " + Year;
	document.querySelector(".model-value").textContent = Model;
	document.querySelector(".camera-number-value").textContent = CameraNumber;
	document.querySelector(".shift-number-value").textContent = Shift;

	if (error === true) {
		document.querySelector(".calculator input").classList.add("error");
	} else {
		document.querySelector(".calculator-results").style.display = "block";
	}

	

}

function copyToClipboard() {
    const iframeInput = document.getElementById('iframe-code');
    const copyButton = document.querySelector('.embed-code button');

    iframeInput.select();
    document.execCommand('copy');

    // Change button text and color
    copyButton.textContent = "Copied";
    copyButton.style.backgroundColor = "#4CAF50"; // Change to any color you prefer

    // Revert button text and color after 3 seconds
    setTimeout(function() {
        copyButton.textContent = "Copy";
        copyButton.style.backgroundColor = "#333"; // Initial color
    }, 3000);
}