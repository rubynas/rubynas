angular.module('rubynas', ['layout', 'user']).
  config ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode(true)
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