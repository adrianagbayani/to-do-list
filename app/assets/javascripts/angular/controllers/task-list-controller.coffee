module = angular.module('task-list', [])

TaskListController = ($scope, $http, $rootScope) ->
	$scope.test = "Hello World Task List"
	$scope.newTaskList = {}

	$scope.$on('login', (e, args) ->
		$scope.init()
	)

	$scope.init = ->
		$scope.fetch()
		initNewTaskList()

	$scope.fetch = ->
		$http.get("/task_lists").
			then (data) ->
				if (data.data.authentication_error)
					$rootScope.authToken = null
				else
					$scope.taskLists = data.data.task_lists

	$scope.saveTaskList = (form) ->
		form.submitted = true
		httpRequest("post", "/task_lists", { task_list: $scope.newTaskList }).
			then (resp) ->
							$scope.taskLists.push(resp.data)
							angular.element("#task_list_modal").modal("hide")
						, (resp) ->
							console.log(resp.data)


	initNewTaskList = ->
		$scope.taskListForm = false
		$scope.newTaskList =
			name: ""

	httpRequest = (method, url, postData) ->
		$http({
			method: method,
			url: url
			data: postData,
		})

module.controller('task-list-controller', ['$scope', '$http', '$rootScope', TaskListController])
