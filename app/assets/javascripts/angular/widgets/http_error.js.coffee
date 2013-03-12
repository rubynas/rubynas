angular.module('httpError', [])
  .service 'httpErrorHandler', () ->
    setup: (handler) ->
      @.trigger = handler
  .factory 'httpErrorInterceptor', ($q, httpErrorHandler) ->
    (promise) ->
      success = (response) ->
        response
      error = (response) ->
        httpErrorHandler.trigger response
        $q.reject(response)
      promise.then(success, error)
  .directive 'httpError', (httpErrorHandler) ->
    link: ($scope, $digest) ->
      httpErrorHandler.setup (response) ->
        $iframe = $digest.find('.http-error.modal').modal().find('iframe')
        $iframe[0].contentDocument.write(response.data)
        $scope.error =
          http:
            status: response.status,
            url: response.config.url,
            method: response.config.method
    templateUrl: "/assets/widgets/http_error.html"
