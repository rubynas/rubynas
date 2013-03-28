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
        $scope.status =
          is_offline: (response.status == 0)
          http:
            status: response.status,
            url: response.config.url,
            method: response.config.method
        $modal = $digest.find('.http-error.modal').modal()
        $iframe = $modal.find('iframe')
        $iframe[0].contentDocument.write(response.data)
    templateUrl: "/assets/widgets/http_error.html"
