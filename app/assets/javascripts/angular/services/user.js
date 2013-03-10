angular.module('user', ['ngResource']).
  factory('User', function($resource) {
    return $resource('/api/users/:cn', {}, { update: { method: 'PUT' } });
  });