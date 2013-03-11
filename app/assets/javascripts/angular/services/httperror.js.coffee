angular.module('httperror-interceptor', []).
  factory 'httpErrorInterceptor', ($q, $rootScope) ->
    (promise) ->
      success = (response) ->
        response
      error = (response) ->
        console.log "errorEmited"
        $rootScope.$emit('httpError', response)
        $q.reject(response)
      promise.then(success, error)
