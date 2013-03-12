angular.module('httpError', [])
  .factory 'httpErrorInterceptor', ($q, $rootScope) ->
    (promise) ->
      success = (response) ->
        response
      error = (response) ->
        console.log "errorEmited"
        $rootScope.$emit('httpError', response)
        $q.reject(response)
      promise.then(success, error)
  .directive 'httpError', () ->
    controller: ($rootScope, $scope) ->
      $rootScope.$on 'httpError', (event, response) ->
        $iframe = $('#error-info').modal().find('iframe')
        $iframe[0].contentDocument.write(response.data)
        $scope.error =
          http:
            status: response.status,
            url: response.config.url,
            method: response.config.method
    templateUrl: "/assets/widgets/http_error.html"
