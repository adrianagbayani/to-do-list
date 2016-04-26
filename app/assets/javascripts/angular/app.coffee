module = angular.module('todoapp', [
	'task-list',
	'ui.router',
	'templates'
	])

module.run [
	'$http',
	'$rootScope',
	'$state'
	($http, $rootScope,$state) ->

		$rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
			#$state.go("tasks") if !!localStorage["auth_token"] && toState.name == 'login'

		$http.defaults.headers.common['Accept'] = 'application/json version=1'
		if !!(auth_token = localStorage.auth_token)
			$rootScope.authToken = auth_token
			$http.defaults.headers.common['X-Auth-Token'] = $rootScope.authToken


		return
]



module.config [
  '$locationProvider', '$urlRouterProvider','$stateProvider',
  ($locationProvider, $urlRouterProvider,$stateProvider) ->

    $locationProvider.html5Mode(true)
    #$urlRouterProvider.otherwise('/login')


    $stateProvider
      .state 'login',
        url: '/login',
        templateUrl: 'login.html'
        controller: 'loginController'

    $stateProvider
      .state 'tasks',
        url: '/tasks',
        abstract: true,
        controller: 'task-list-controller',
        templateUrl: 'task_layout.html'

    $stateProvider
      .state 'tasks.index',
        url: '/',
        templateUrl: 'tasks.html'

    $stateProvider
      .state 'tasks.new',
        url: '/new',
        templateUrl: 'tasks_new.html'

    $stateProvider
      .state 'tasks.edit',
        url: '/:id/edit',
        templateUrl: 'tasks_edit.html'


]
#
# module.controller 'BaseCtrl',
# ['$scope','$http','$rootScope','$timeout','$window',
# ($scope,$http,$rootScope,$timeout,$window) ->
# 	$scope.zz = "ss"
#
# ]

#
# module.controller 'LoginCtrl',
# ['$scope','$http','$rootScope','$timeout','$window',
# ($scope,$http,$rootScope,$timeout,$window) ->
# 	$scope.zz = "ss"
# 	debugger
# ]
