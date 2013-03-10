# app
rubynas = angular.module('rubynas', ['layout', 'user'])

# backend errors
rubynas.factory 'httpErrorInterceptor', ($q) ->
  (promise) ->
    success = (response) ->
      response
    error = (response) ->
      $('html').html(response.data)
      $q.reject(response)
    promise.then(success, error)

# configuration
rubynas.config ($routeProvider, $locationProvider, $httpProvider) ->
  $httpProvider.responseInterceptors.push('httpErrorInterceptor')
  $locationProvider.html5Mode(true)
  $routeProvider
    .when "/system/summary",
      controller: SystemSummaryController,
      templateUrl: "/assets/system/summary.html"
    .when "/users",
      controller: UserListController,
      templateUrl: "/assets/users/index.html"
    .when "/users/:cn",
      controller: UserController,
      templateUrl: "/assets/users/form.html"
    .otherwise
      redirectTo: '/system/summary'


