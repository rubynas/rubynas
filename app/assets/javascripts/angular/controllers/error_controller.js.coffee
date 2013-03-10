window.ErrorController = ($rootScope, $scope) ->
  $rootScope.$on 'httpError', (event, response) ->
    $scope.error = {
      http: {
        status: response.status,
        url: response.config.url,
        method: response.config.method
      }
    }
    