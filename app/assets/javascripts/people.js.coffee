$ ->
  $('#sort_control select')
    .change ->
      $(@).parent('form').submit()