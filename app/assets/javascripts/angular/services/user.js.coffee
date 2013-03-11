angular.module('user', ['ngResource']).
  factory 'User', ($resource) ->
    $resource '/api/users/:cn', {}, 
      update:
        method: 'PUT'
