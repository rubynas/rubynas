angular.module('timeago', []).
  filter 'timeago', () ->
    (time) ->
      jQuery.timeago(time) if time?     
