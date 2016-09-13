#= require active_admin/base
#= require select2

$(document).ready ->
  # google map autocomplete
  fillInAddress1 = ->
    place = this.getPlace()
    latitude = place.geometry.location.lat()
    longitude = place.geometry.location.lng()
    $('#task_addrlat').val(latitude)
    $('#task_addrlng').val(longitude)

  fillInAddress2 = ->
    place = this.getPlace()
    latitude = place.geometry.location.lat()
    longitude = place.geometry.location.lng()
    $('#task_pick_up_addrlat').val(latitude)
    $('#task_pick_up_addrlng').val(longitude)

  fillInAddress3 = ->
    place = this.getPlace()
    latitude = place.geometry.location.lat()
    longitude = place.geometry.location.lng()
    $('#provider_addrlat').val(latitude)
    $('#provider_addrlng').val(longitude)

  if $('#task_address').length > 0
    input = document.getElementById('task_address')
    autocomplete1 = new (google.maps.places.Autocomplete)(input, {types: ['geocode']});
    autocomplete1.addListener('place_changed', fillInAddress1);

    input = document.getElementById('task_pick_up_address')
    autocomplete2 = new (google.maps.places.Autocomplete)(input, {types: ['geocode']});
    autocomplete2.addListener('place_changed', fillInAddress2);

  if $('#provider_address1').length > 0
    input = document.getElementById('provider_address1')
    autocomplete3 = new (google.maps.places.Autocomplete)(input, {types: ['geocode']});
    autocomplete3.addListener('place_changed', fillInAddress3);


  # select2 styling
  $("#provider_setting_attributes_type_ids").select2({width: "40%"})

