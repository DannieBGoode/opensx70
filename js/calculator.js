function calculateSerialNumber() {

	document.querySelector(".calculator-results").style.display = "none";
	document.querySelector(".calculator input").classList.remove("error")
	let error = false;

	let serialNumber = document.querySelector("#calculator-input").value;
	let configNumber = serialNumber[0];
	let MonthNumber = serialNumber[1];
	let ModelNumber = serialNumber[3];
	let CameraNumber = serialNumber.substring(4, 9);
	let ShiftNumber = serialNumber.substring(9, 11);

	let configurationBase =  {
		"": "nothing - Non-Hybrid",
		"F": "Fairchild	",
		"0": "hybrid	\"Q\" shutter",
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
		"4": "Sonar",
		"6": "SLR680"
	}
	let configuration = configurationBase[configNumber];
	let Month = MonthBase[MonthNumber];
	let YearNumber;
	if ( ((parseInt(configNumber) <= 4) && (parseInt(configNumber) >= 0) || configNumber === "F" || configNumber === "") || (serialNumber[2] === "1") || ((serialNumber[2] <= "1") || (serialNumber[2] >= "7")) ) {
		YearNumber = serialNumber[2]
	} else {
		YearNumber = "x" + serialNumber[2];
	}
	let Year = YearBase[YearNumber];
	let Model = ModelBase[ModelNumber];

	

	if ((configuration === undefined) || (Month === undefined) || (Year === undefined) || (Model === undefined)) {
		error = true;
	}

	let Day;
	if (parseInt(ShiftNumber) % 3 === 0) {
		Day = parseInt(ShiftNumber) / 3;
	} else if ((parseInt(ShiftNumber) + 1) % 3 === 0) {
		Day = (parseInt(ShiftNumber) + 1) / 3;
	} else if ((parseInt(ShiftNumber) + 2) % 3 === 0) {
		Day = (parseInt(ShiftNumber) + 2) / 3;
	} else {
		error = true;
	}

	document.querySelector(".serial-number-value").textContent = serialNumber;
	document.querySelector(".config-value").textContent = configuration;
	document.querySelector(".birthday-value").textContent = Day + " " + Month + ", " + Year;
	document.querySelector(".model-value").textContent = Model;
	document.querySelector(".camera-number-value").textContent = CameraNumber;
	document.querySelector(".shift-number-value").textContent = ShiftNumber;

	if (error === true) {
		document.querySelector(".calculator input").classList.add("error");
	} else {
		document.querySelector(".calculator-results").style.display = "block";
	}

	

}