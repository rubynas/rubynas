angular.module('rubynas', [
  'layout', 'httpError'
  'user', 'group', 'volume'
  'timeago', 'bytes'
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
    .when "/groups",
      controller: GroupListController,
      templateUrl: "/assets/groups/index.html"
    .when "/groups/:cn",
      controller: GroupController,
      templateUrl: "/assets/groups/form.html"
    .when "/volumes",
      controller: VolumeListController,
      templateUrl: "/assets/volumes/index.html"
    .otherwise
      redirectTo: '/system/summary'
