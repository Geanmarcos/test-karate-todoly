Feature: ProjectConfig
  Background: configuration
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    * def createProject = 'classpath:helpers/createProjectData.feature'
    * def deleteProject = 'classpath:helpers/deleteProjectData.feature'

# 1. Flujo End to End

  Scenario: Create Project
    #create
    Given path '/api/projects.json'
    * def payload =
    """
    {
      "Content": "Karate",
      "Icon": 7
    }
    """
    * request payload
    When method post
    Then status 200
    * print response
    * match response.Content == 'Karate'
    * def PROJECT_ID = response.Id
    * print "********** ID **********"
    * print PROJECT_ID

    #update
    Given path '/api/projects/' + PROJECT_ID + '.json'
    * def payload =
    """
    {
      "Content": "KarateUpdated",
      "Icon": 10
    }
    """
    * request payload
    When method put
    Then status 200
    * match response.Content == 'KarateUpdated'
    * print response

    #Read
    Given path '/api/projects/' + PROJECT_ID + '.json'
    When method get
    Then status 200
    * match response.Content == 'KarateUpdated'
    * print response

    #Delete
    Given path '/api/projects/' + PROJECT_ID + '.json'
    When method delete
    Then status 200
    * match response.Content == 'KarateUpdated'
    * match response.Deleted == true
    * print response

# 2. Escenarios independientes

  Scenario: Crear un proyecto
    * def content = 'Create'
    * def icon = 7
    Given path '/api/projects.json'
    * request read('classpath:data/payload.json')
    When method post
    Then status 200
    * match response contains { Content: '#(content)', Icon: #(icon) }
    * def projectId = response.Id
    * call read(deleteProject) { projectId: '#(projectId)' }

  Scenario: Leer un proyecto
    # crear proyecto
    * def content = 'Read Proyecto'
    * def icon = 5
    * def projectCreated = call read(createProject){ content: '#(content)', icon: #(icon) }
    Given path '/api/projects/'+ projectCreated.projectId +'.json'
    When method get
    Then status 200
    * match response.Content == content
    * call read(deleteProject) { projectId: '#(projectCreated.projectId)' }

  Scenario: Actualizar un proyecto
    # crear proyecto
    * def content = 'Crear Proyecto'
    * def icon = 1
    * def projectCreated = call read(createProject){ content: '#(content)', icon: #(icon) }
    # actualizar proyecto
    * def content = 'Actualizar Proyecto'
    * def icon = 2
    Given path '/api/projects/'+ projectCreated.projectId +'.json'
    * request read('classpath:data/payload.json')
    When method put
    Then status 200
    * match response contains { Content: '#(content)', Icon: #(icon) }
    * call read(deleteProject) { projectId: '#(projectCreated.projectId)' }

  Scenario: Eliminar un proyecto
    # crear proyecto
    * def content = 'Crear Proyecto'
    * def icon = 2
    * def projectCreated = call read(createProject){ content: '#(content)', icon: #(icon) }
    Given path '/api/projects/'+ projectCreated.projectId +'.json'
    When method delete
    Then status 200
    * match response contains { Content: '#(content)', Icon: #(icon), Deleted: true }

