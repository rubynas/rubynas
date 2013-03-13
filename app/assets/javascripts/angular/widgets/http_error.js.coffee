angular.module('httpError', [])
  .service 'httpErrorScope', ($rootScope) ->
    $rootScope.$new()
  .factory 'httpErrorInterceptor', ($q, httpErrorScope) ->
    (promise) ->
      success = (response) ->
        response
      error = (response) ->
        httpErrorScope.$emit 'error', response
        $q.reject(response)
      promise.then(success, error)
  .directive 'httpError', (httpErrorScope) ->
    link: ($scope, $digest) ->
      httpErrorScope.$on 'error', (event, response) ->
        $iframe = $digest.find('.http-error.modal').modal().find('iframe')
        $iframe[0].contentDocument.write(response.data)
        $scope.error =
          http:
            status: response.status,
            url: response.config.url,
            method: response.config.method
    templateUrl: "/assets/widgets/http_error.html"
