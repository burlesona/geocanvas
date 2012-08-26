var poly;
var map;
var geocoder = new google.maps.Geocoder();

// Create a meausure object to store our markers, MVCArrays, lines and polygons
var measure = {
	mvcLine: new google.maps.MVCArray(),
	mvcPolygon: new google.maps.MVCArray(),
	mvcMarkers: new google.maps.MVCArray(),
	line: null,
	polygon: null
};

function initialize() {
	// var chicago = new google.maps.LatLng(41.879535, -87.624333);
	var houston = new google.maps.LatLng(29.818592, -95.372137);
	var myOptions = {
		zoom: 10,
		center: houston,
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		draggableCursor: "crosshair"
	};

	map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);

	var polyOptions = {
		strokeColor: '#000000',
		strokeOpacity: 1.0,
		strokeWeight: 3
	}

	poly = new google.maps.Polyline(polyOptions);
	poly.setMap(map);

	// Add a listener for the click event
	//google.maps.event.addListener(map, 'click', addLatLng);
	google.maps.event.addListener(map, "click", function (evt) {
		// When the map is clicked, pass the LatLng obect to the measureAdd function
		measureAdd(evt.latLng);
	});
}

function locationSearch() {
	var string = document.getElementById('lstring').value
	geocoder.geocode(
		{address: string},
		function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
				displayCoords(
					results[0].geometry.location.lat(),
					results[0].geometry.location.lng()
				);
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    }
  );
}

function displayCoords(lat,lng) {
	document.getElementById('mlat').innerHTML = formatNumber(lat);
	document.getElementById('mlon').innerHTML = formatNumber(lng);
}

function formatNumber( num ) {
		x = num.toFixed(2);
    var parts = x.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}


// Handles click events on a map, and adds a new point to the Polyline.
// param {MouseEvent} mouseEvent
function addLatLng(event) {
	var path = poly.getPath();

	// Because path is an MVCArray, we can simply append a new coordinate
	// and it will automatically appear
	path.push(event.latLng);

	// Add a new marker at the new plotted point on the polyline.
	var marker = new google.maps.Marker({
		position: event.latLng,
		title: '#' + path.getLength(),
		map: map
	});

	//debugger
	displayCoords(
		path.getAt(path.getLength() - 1).lat(),
		path.getAt(path.getLength() - 1).lng()
	);

	if (path.getLength() > 1) {
		document.getElementById('mdistance').value = 
			distVincenty(
				path.getAt(0).lat(),
				path.getAt(0).lng(),
				path.getAt(1).lat(),
				path.getAt(1).lng()
			);
	}
}

function measureAdd(latLng) {

	// Add a draggable marker to the map where the user clicked
	var marker = new google.maps.Marker({
		map: map,
		position: latLng,
		draggable: true,
		raiseOnDrag: false,
		title: "Drag me to change shape",
		icon: new google.maps.MarkerImage("marker.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5))
	});

	// Add this LatLng to our line and polygon MVCArrays
	// Objects added to these MVCArrays automatically update the line and polygon shapes on the map
	measure.mvcLine.push(latLng);
	measure.mvcPolygon.push(latLng);

	// Push this marker to an MVCArray
	// This way later we can loop through the array and remove them when measuring is done
	measure.mvcMarkers.push(marker);

	// Get the index position of the LatLng we just pushed into the MVCArray
	// We'll need this later to update the MVCArray if the user moves the measure vertexes
	var latLngIndex = measure.mvcLine.getLength() - 1;

	displayCoords(
		measure.mvcLine.getAt(measure.mvcLine.getLength() - 1).lat(),
		measure.mvcLine.getAt(measure.mvcLine.getLength() - 1).lng()
	);

	// When the user mouses over the measure vertex markers, change shape and color to make it obvious they can be moved
	google.maps.event.addListener(marker, "mouseover", function () {
		marker.setIcon(new google.maps.MarkerImage("hovermarker.png", new google.maps.Size(15, 15), new google.maps.Point(0, 0), new google.maps.Point(8, 8)));
	});

	// Change back to the default marker when the user mouses out
	google.maps.event.addListener(marker, "mouseout", function () {
		marker.setIcon(new google.maps.MarkerImage("marker.png", new google.maps.Size(9, 9), new google.maps.Point(0, 0), new google.maps.Point(5, 5)));
	});

	// When the measure vertex markers are dragged, update the geometry of the line and polygon by resetting the
	// LatLng at this position
	google.maps.event.addListener(marker, "drag", function (evt) {
		measure.mvcLine.setAt(latLngIndex, evt.latLng);
		measure.mvcPolygon.setAt(latLngIndex, evt.latLng);
	});

	// When dragging has ended and there is more than one vertex, measure length, area.
	google.maps.event.addListener(marker, "dragend", function () {
		if (measure.mvcLine.getLength() > 1) {
			measureCalc();
		}
	});

	// If there is more than one vertex on the line
	if (measure.mvcLine.getLength() > 1) {
		// If the line hasn't been created yet
		if (!measure.line) {
			// Create the line (google.maps.Polyline)
			measure.line = new google.maps.Polyline({
				map: map,
				clickable: false,
				strokeColor: "#FF0000",
				strokeOpacity: 1,
				strokeWeight: 3,
				path: measure.mvcLine
			});
		}

		// If there is more than two vertexes for a polygon
		if (measure.mvcPolygon.getLength() > 2) {
			// If the polygon hasn't been created yet
			if (!measure.polygon) {
				// Create the polygon (google.maps.Polygon)
				measure.polygon = new google.maps.Polygon({
					clickable: false,
					map: map,
					fillOpacity: 0.25,
					strokeOpacity: 0,
					paths: measure.mvcPolygon
				});
			}
		}
	}

	// If there's more than one vertex, measure length, area.
	if (measure.mvcLine.getLength() > 1) {
		measureCalc();
	}
}

function measureCalc() {
	// Use the Google Maps geometry library to measure the length of the line
	var length = google.maps.geometry.spherical.computeLength(measure.line.getPath());

	//$("#mdistanceft").text(length.toFixed(1) * 3.2808);
	//$("#mdistancemr").text(length.toFixed(1));
	//$("#mdistancemi").text(length.toFixed(1)/1609.34);
	//document.getElementById('mdistance').value = (length * 3.2808).toFixed(2);
	document.getElementById('mdistanceft').value = formatNumber(length * 3.2808);
	document.getElementById('mdistancemr').value = formatNumber(length);
	document.getElementById('mdistancemi').value = formatNumber(length/1609.34);
	//$("#distancemeasured").val(length.toFixed(2));

	// If we have a polygon (>2 vertexes in the mvcPolygon MVCArray)
	if (measure.mvcPolygon.getLength() > 2) {
		// Use the Google Maps geometry library to measure the area of the polygon
		var area = google.maps.geometry.spherical.computeArea(measure.polygon.getPath());

		//$("#marea").text(area.toFixed(1));
		document.getElementById('mareaft').value = formatNumber(area * 3.2808);
		document.getElementById('mareaac').value = formatNumber(area * 3.2808 / 43560);
	}
}

function measureReset() {

	// If we have a polygon or a line, remove them from the map and set null
	if (measure.polygon) {
		measure.polygon.setMap(null);
		measure.polygon = null;
	}

	if (measure.line) {
		measure.line.setMap(null);
		measure.line = null
	}

	// Empty the mvcLine and mvcPolygon MVCArrays
	measure.mvcLine.clear();
	measure.mvcPolygon.clear();

	// Loop through the markers MVCArray and remove each from the map, then empty it
	measure.mvcMarkers.forEach(function (elem, index) {
		elem.setMap(null);
	});

	measure.mvcMarkers.clear();

	//$("#mdistance,#marea").text(0);
	document.getElementById('mdistanceft').value = "";
	document.getElementById('mdistancemr').value = "";
	document.getElementById('mdistancemi').value = "";
}

function distVincenty(lat1, lon1, lat2, lon2) {
	var a = 6378137, b = 6356752.314245, f = 1 / 298.257223563;  // WGS-84 ellipsoid params
	var L = (lon2 - lon1).toRad();
	var U1 = Math.atan((1 - f) * Math.tan(lat1.toRad()));
	var U2 = Math.atan((1 - f) * Math.tan(lat2.toRad()));
	var sinU1 = Math.sin(U1), cosU1 = Math.cos(U1);
	var sinU2 = Math.sin(U2), cosU2 = Math.cos(U2);
	var lambda = L, lambdaP, iterLimit = 100;

	do {

		var sinLambda = Math.sin(lambda), cosLambda = Math.cos(lambda);
		var sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
		  (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));

		if (sinSigma == 0) return 0;  // co-incident points
		var cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
		var sigma = Math.atan2(sinSigma, cosSigma);
		var sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
		var cosSqAlpha = 1 - sinAlpha * sinAlpha;
		var cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

		if (isNaN(cos2SigmaM)) cos2SigmaM = 0;  // equatorial line: cosSqAlpha=0 (§6)
		var C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
		lambdaP = lambda;
		lambda = L + (1 - C) * f * sinAlpha *
		  (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));

	} while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);

	if (iterLimit == 0) return NaN  // formula failed to converge
	var uSq = cosSqAlpha * (a * a - b * b) / (b * b);
	var A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
	var B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
	var deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
	  B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
	var s = b * A * (sigma - deltaSigma) * 3.2808399; // convert to feet

	s = s.toFixed(3); // round to 1mm precision
	return s;

	// note: to return initial/final bearings in addition to distance, use something like:
	//var fwdAz = Math.atan2(cosU2 * sinLambda, cosU1 * sinU2 - sinU1 * cosU2 * cosLambda);
	//var revAz = Math.atan2(cosU1 * sinLambda, -sinU1 * cosU2 + cosU1 * sinU2 * cosLambda);
	//return { distance: s, initialBearing: fwdAz.toDeg(), finalBearing: revAz.toDeg() };
}

// Converts numeric degrees to radians */
if (typeof (Number.prototype.toRad) === "undefined") {
	Number.prototype.toRad = function () {
		return this * Math.PI / 180;
	}
}