$('.date-picker').datepicker {
  dateFormat: "dd-mm-yy"
}
$('#feature_tag').tokenInput('/features/query.json', { 
  crossDomain: false,
  prePopulate: $('#feature_tag').data("pre")
 })
$('#dev_tag').tokenInput('/developers/query.json', { 
  crossDomain: false,
  prePopulate: $('#dev_tag').data("pre")
})
