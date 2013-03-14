angular.module('group', ['ngResource']).
  factory 'Group', ($resource) ->
    $resource '/api/groups/:cn', {}, 
      update:
        method: 'PUT'
