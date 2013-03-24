angular.module('system_information', ['ngResource'])
  .factory 'SystemInformation', ($resource) ->
    $resource '/api/system/information'
