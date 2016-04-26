module = angular.module('todoapp', [
	'login',
	'task-list'
	])

module.run [
	'$http',
	'$rootScope',
	($http, $rootScope) ->
		$http.defaults.headers.common['Accept'] = 'application/json version=1'
		if !!(auth_token = localStorage.auth_token)
			$rootScope.authToken = auth_token
			$http.defaults.headers.common['X-Auth-Token'] = $rootScope.authToken
]
