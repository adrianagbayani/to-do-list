module = angular.module('task-list', [])

TaskListController = ($scope, $http, $filter, $rootScope) ->

	$scope.test = "Hello World Task List"
	$scope.newTaskList = {}
	$scope.newTask = {}
	$scope.newNote = {}


	$scope.init = ->
		$scope.fetch()

	$scope.fetch = ->
		$http.get("/task_lists").
			then (data) ->
				if (data.data.authentication_error)
					$rootScope.authToken = null
				else
					$scope.taskLists = data.data.task_lists

	# Start Task List
	$scope.deleteTaskList = (taskList) ->
		$http.delete("/task_lists/#{taskList.id}").
			then (response) ->
				if (response.data)
					$scope.taskLists.splice($scope.taskLists.indexOf(taskList), 1)

	$scope.saveTaskList = (form) ->
		form.submitted = true
		$http.post("/task_lists", { task_list: $scope.newTaskList }).
			then (resp) ->
							$scope.taskLists.push(resp.data)
							angular.element("#task_list_modal").modal("hide")
						, (resp) ->
							console.log(resp.data)

	$scope.editTaskList = (taskList) ->
		taskList.editable = true

	$scope.updateTaskList = (taskList) ->
		$http.patch("/task_lists/#{taskList.id}", { task_list: taskList }).
			then (response) ->
				$scope.taskLists[$scope.taskLists.indexOf(taskList)] = response.data
				# taskList = response.data
				taskList.editable = false

	$scope.initNewTaskList = ->
		$scope.taskListForm = false
		$scope.newTaskList =
			name: ""

	# Start Task Here
	$scope.saveTask = (form) ->
		form.submitted = true
		$scope.newTask.due_date = $filter('date')($scope.newTask.due_date_unformatted, "M/d/yyyy")
		$http.post("/task_lists/#{$scope.newTask.task_list.id}/tasks", { task: $scope.newTask }).
			then (response) ->
				$scope.initNewTask
				$scope.taskLists[$scope.taskLists.indexOf($scope.newTask.task_list)].tasks.push(response.data)
				angular.element("#task_modal").modal("hide")

	$scope.editTask = (task) ->
		task.due_date_unformatted = new Date(task.due_date)
		task.editable = true

	$scope.updateTask = (taskList, task) ->
		task.due_date = $filter('date')(task.due_date_unformatted, "M/d/yyyy")
		$http.patch("/task_lists/#{taskList.id}/tasks/#{task.id}", { task: task }).
			then (response) ->
				taskListIndex = $scope.taskLists.indexOf(taskList)
				taskIndex = taskList.tasks.indexOf(task)

				$scope.taskLists[taskListIndex].tasks[taskIndex] = response.data
				taskList.editable = false

	$scope.deleteTask = (taskList, task) ->
		$http.delete("/task_lists/#{taskList.id}/tasks/#{task.id}").
			then (response) ->
				if (response.data)
					taskList.tasks.splice(taskList.tasks.indexOf(task), 1)

	$scope.initNewTask = (taskList) ->
		$scope.taskForm = false
		$scope.newTask =
			title: ""
			due_date_unformatted: new Date()
			task_list: taskList

	# Start Notes
	$scope.saveNote = (form) ->
		form.submitted = true
		$http.post("/task_lists/#{$scope.newNote.task_list.id}/tasks/#{$scope.newNote.task.id}/notes", { note: $scope.newNote }).
			then (response) ->
				taskListIndex = $scope.taskLists.indexOf($scope.newNote.task_list)
				taskIndex = $scope.newNote.task_list.tasks.indexOf($scope.newNote.task)
				$scope.taskLists[taskListIndex].tasks[taskIndex].notes.push(response.data)
				angular.element("#note_modal").modal("hide")

	$scope.editNote = (note) ->
		note.editable = true

	$scope.updateNote = (taskList, task, note) ->
		$http.patch("/task_lists/#{taskList.id}/tasks/#{task.id}/notes/#{note.id}", { note: note }).
			then (response) ->
				taskListIndex = $scope.taskLists.indexOf(taskList)
				taskIndex = taskList.tasks.indexOf(task)
				noteIndex = task.notes.indexOf(note)

				$scope.taskLists[taskListIndex].tasks[taskIndex].notes[noteIndex] = response.data
				note.editable = false

	$scope.deleteNote = (taskList, task, note) ->
		$http.delete("/task_lists/#{taskList.id}/tasks/#{task.id}/notes/#{note.id}").
			then (response) ->
				if (response.data)
					task.notes.splice(task.notes.indexOf(note), 1)

	$scope.initNewNote = (taskList, task) ->
		$scope.noteForm = false
		$scope.newNote =
			message: ""
			task_list: taskList
			task: task

	httpRequest = (method, url, postData) ->
		$http({
			method: method,
			url: url
			data: postData,
		})

	$scope.init()

module.controller('task-list-controller', ['$scope', '$http', '$filter', '$rootScope', TaskListController])
