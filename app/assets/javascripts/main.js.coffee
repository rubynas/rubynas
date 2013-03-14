angular.module('rubynas', [
  'layout', 'httpError'
  'user', 'group', 'system_information',
  'timeago'
]).config ($routeProvider, $locationProvider, $httpProvider) ->
  # Show backend http errors
  $httpProvider.responseInterceptors.push('httpErrorInterceptor')
  
  # Enable HTML 5 History API
  $locationProvider.html5Mode(true)
  
  # Application routes
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
