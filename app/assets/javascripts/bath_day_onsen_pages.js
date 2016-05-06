(function () {

  var isNotDayOnsenPage = ! $('.bath-day-onsen-pages').length;
  if (isNotDayOnsenPage) {
    return;
  }

  var stations = document.getElementById('initial-data').getAttribute('data-json');
  stations = JSON.parse(stations);

  var map = null;
  var markersMap = {};

  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { address: '埼玉県' }, function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {

      var myLocation = results[0].geometry.location;

      map = new google.maps.Map(document.getElementById("map-canvas"), {
        zoom: 10,
        center: myLocation,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });

      stations.forEach(function (station) {
        markersMap[station.id] = addMarker(station, map);
      });

    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });

  var $pages = $('.bath-day-onsen-page');
  $pages.hover(function (event) {
    var id = $(event.target).parent().attr('id');
    if (id) {
      markersMap[id].setIcon(getPinImage('yellow'));
    }
  }, function (event) {
    var id = $(event.target).parent().attr('id');
    if (id) {
      markersMap[id].setIcon(getPinImage('blue'));
    }
  });

  $pages.click(function (event) {
    var id = $(event.target).parent().attr('id');
    if (id) {
      console.log(markersMap[id])
      map.panTo(markersMap[id].position);
    }
  });

  var $content = $('.bath-day-onsen-map__content'), offset = $content.offset();
  $(window).scroll(function () {
    if($(window).scrollTop() > offset.top - 20) {
      $content.addClass('bath-day-onsen-map__content--fixed');
    } else {
      $content.removeClass('bath-day-onsen-map__content--fixed');
    }
  });

  function addMarker(station, map) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(station.latitude, station.longitude),
      map: map,
      icon: getPinImage('blue'),
      title: station.name,
      zIndex: 1
    });

    google.maps.event.addListener(marker, 'mouseover', function() {
      marker.setIcon(getPinImage('yellow'));
      $('#' + station.id).addClass('bath-day-onsen-page--hover');
    });
    google.maps.event.addListener(marker, 'mouseout', function() {
      marker.setIcon(getPinImage('blue'));
      $('#' + station.id).removeClass('bath-day-onsen-page--hover');
    });
    google.maps.event.addListener(marker, 'click', function() {
      $('html, body').animate({
        scrollTop: $('#' + station.id).offset().top
      }, 200);
    });

    return marker;
  }

  function getPinImage(color) {
    return {
      url: '/assets/map/pin-' + color + '.png',
      size: new google.maps.Size(32, 32),
      origin: new google.maps.Point(0, 0),
      anchor: new google.maps.Point(16, 32),
      scaledSize: new google.maps.Size(32, 32)
    };
  }
  
})();

