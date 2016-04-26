module = angular.module('login', [])

LoginController = ($scope, $http, $rootScope) ->

	$scope.test = "Hello World Login"
	$scope.user = {}

	$scope.login = ->
		$http.post("/users/sign_in", { user: $scope.user }).
			then (data) ->
				if data.data && data.data.user
					$rootScope.authToken = data.data.user.auth_token
					localStorage.setItem('auth_token', $rootScope.authToken)
					$http.defaults.headers.common['X-Auth-Token'] = $rootScope.authToken
					$rootScope.$broadcast('login', $rootScope.authToken)

module.controller('login-controller', ['$scope', '$http', '$rootScope', LoginController])
