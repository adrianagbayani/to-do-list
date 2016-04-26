
LoginController = ($scope, $http, $rootScope,$state) ->

	auth_token = localStorage["auth_token"]
	$state.go("tasks") if !!auth_token

	$scope.test = "Hello World Login"
	$scope.user = {}
	$scope.login = ->
		$http.post("/users/sign_in", { user: $scope.user }).
			then (data) ->
				if data.data && data.data.user
					$rootScope.authToken = data.data.user.auth_token
					localStorage.setItem('auth_token', $rootScope.authToken)
					$http.defaults.headers.common['X-Auth-Token'] = $rootScope.authToken
					$state.go("tasks")

LoginController.$inject = ['$scope', '$http', '$rootScope','$state']
angular.module('todoapp').controller('loginController', LoginController)
