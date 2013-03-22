angular.module('volume', ['ngResource']).
  factory 'Volume', ($resource) ->
    $resource '/api/volumes/:id', {}, 
      update:
        method: 'PUT'
