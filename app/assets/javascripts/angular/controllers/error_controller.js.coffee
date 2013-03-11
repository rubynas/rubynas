window.ErrorController = ($rootScope, $scope) ->
  $rootScope.$on 'httpError', (event, response) ->
    $iframe = $('#error-info').modal().find('iframe')
    $iframe[0].contentDocument.write(response.data)
    $scope.error = {
      http: {
        status: response.status,
        url: response.config.url,
        method: response.config.method
      }
    }
    