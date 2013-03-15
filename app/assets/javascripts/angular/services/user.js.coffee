angular.module('user', ['ngResource']).
  factory 'User', ($resource) ->
    $resource '/api/users/:cn', {}, 
      update:
        method: 'PUT'
      template:
        method: 'GET'
        params:
          cn: 'template'
