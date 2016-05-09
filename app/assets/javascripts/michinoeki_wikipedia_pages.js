if ($('.michinoeki-wikipedia-pages-index').length > 0) {
  // index
  (function () {

    var locations = document.getElementById('initial-data').getAttribute('data-json');
    locations = JSON.parse(locations);

    var map = null;
    var markersMap = {};

    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { address: '埼玉県' }, function (results, status) {
      if (status == google.maps.GeocoderStatus.OK) {

        var myLocation = results[0].geometry.location;

        map = new google.maps.Map(document.getElementById("map-canvas"), {
          zoom: 7,
          center: myLocation,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        locations.forEach(function (location) {
          markersMap[location.id] = addMarker(location, map);
        });

      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });

    var $pages = $('.michinoeki-wikipedia-pages-index__page');
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
        map.panTo(markersMap[id].position);
      }
    });

    var $content = $('.michinoeki-wikipedia-pages-index__map-content'), offset = $content.offset();
    $(window).scroll(function () {
      if($(window).scrollTop() > offset.top - 20) {
        $content.addClass('michinoeki-wikipedia-pages-index__map-content--fixed');
      } else {
        $content.removeClass('michinoeki-wikipedia-pages-index__map-content--fixed');
      }
    });

    function addMarker(location, map) {
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(location.latitude, location.longitude),
        map: map,
        icon: getPinImage('blue'),
        title: location.name,
        zIndex: 1
      });

      google.maps.event.addListener(marker, 'mouseover', function() {
        marker.setIcon(getPinImage('yellow'));
        $('#' + location.id).addClass('michinoeki-wikipedia-pages-index__page--hover');
      });
      google.maps.event.addListener(marker, 'mouseout', function() {
        marker.setIcon(getPinImage('blue'));
        $('#' + location.id).removeClass('michinoeki-wikipedia-pages-index__page--hover');
      });
      google.maps.event.addListener(marker, 'click', function() {
        $('html, body').animate({
          scrollTop: $('#' + location.id).offset().top
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
} else if ($('.michinoeki-wikipedia-pages-show').length > 0) {
  // show
  var data = document.getElementById('initial-data').getAttribute('data-json');
  data = JSON.parse(data);
  locations = data.locations;
  stationName = '道の駅' + data.name;

  var map = null;
  var centerMarker = null;
  var markersMap = {};

  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { address: stationName }, function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {

      var myLocation = results[0].geometry.location;

      map = new google.maps.Map(document.getElementById("map-canvas"), {
        zoom: 11,
        center: myLocation,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });

      centerMarker = new google.maps.Marker({
        map: map ,
        position: myLocation,
      });

      locations.forEach(function (location) {
        markersMap[location.id] = addMarker(location, map);
      });

    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });

  var $pages = $('.michinoeki-wikipedia-pages-show__page');
  $pages.hover(function (event) {
    var id = $(event.target).attr('id');
    if (id) {
      markersMap[id].setIcon(getPinImage('yellow'));
    }
  }, function (event) {
    var id = $(event.target).attr('id');
    if (id) {
      markersMap[id].setIcon(getPinImage('blue'));
    }
  });

  $pages.click(function (event) {
    var id = $(event.target).attr('id');
    if (id) {
      map.panTo(markersMap[id].position);
    }
  });

  var $content = $('.michinoeki-wikipedia-pages-show__map-content'), offset = $content.offset();
  $(window).scroll(function () {
    if($(window).scrollTop() > offset.top - 20) {
      $content.addClass('michinoeki-wikipedia-pages-show__map-content--fixed');
    } else {
      $content.removeClass('michinoeki-wikipedia-pages-show__map-content--fixed');
    }
  });

  function addMarker(location, map) {
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(location.latitude, location.longitude),
      map: map,
      icon: getPinImage('blue'),
      title: location.name,
      zIndex: 1
    });

    google.maps.event.addListener(marker, 'mouseover', function() {
      marker.setIcon(getPinImage('yellow'));
      $('#' + location.id).addClass('michinoeki-wikipedia-pages-show__page--hover');
    });
    google.maps.event.addListener(marker, 'mouseout', function() {
      marker.setIcon(getPinImage('blue'));
      $('#' + location.id).removeClass('michinoeki-wikipedia-pages-show__page--hover');
    });
    google.maps.event.addListener(marker, 'click', function() {
      $('html, body').animate({
        scrollTop: $('#' + location.id).offset().top
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

}





