# app
rubynas = angular.module('rubynas', [])

# application errors
rubynas.factory '$exceptionHandler', ($injector) ->
  (exception, cause) ->
    console.log exception.message
    console.log exception

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
    .otherwise
      redirectTo: '/system/summary'


