# app
rubynas = angular.module('rubynas', ['layout', 'user'])

# application errors
rubynas.factory '$exceptionHandler', ($injector) ->
  (exception, cause) ->
    console.log exception.message
    console.log exception

# backend errors
rubynas.factory 'httpErrorInterceptor', ($q, $rootScope) ->
  (promise) ->
    success = (response) ->
      response
    error = (response) ->
      $iframe = $('#error-info').modal().find('iframe')
      $iframe[0].contentDocument.write(response.data)
      $rootScope.$emit('httpError', response)
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


