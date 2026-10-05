@EndToEndTest
Feature: ProjectConfig

  Background: configuration
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    * def createProject = 'classpath:helpers/createProjectData.feature'
    * def deleteProject = 'classpath:helpers/deleteProjectData.feature'
    * def createItem = 'classpath:helpers/createItemData.feature'
    * def deleteItem = 'classpath:helpers/deleteItemData.feature'

# 1. Flujo End to End

  Scenario: Create Project
    #create project
    Given path '/api/projects.json'
    * def cContentProject = "Karate Project"
    * def cIconProject = 7
    * def payload =
    """
    {
      "Content": "#(cContentProject)",
      "Icon": "#(cIconProject)"
    }
    """
    * request payload
    When method post
    Then status 200
    * print response
    * match response contains { Content: '#(cContentProject)', Icon: #(cIconProject) }
    * def PROJECT_ID = response.Id
    * print "********** ID **********"
    * print PROJECT_ID

    #update project
    Given path '/api/projects/' + PROJECT_ID + '.json'
    * def uContentProject = "Update Karate Project"
    * def uIconProject = 7
    * def payload =
    """
    {
      "Content": "#(uContentProject)",
      "Icon": "#(uIconProject)"
    }
    """
    * request payload
    When method put
    Then status 200
    * match response contains { Content: '#(uContentProject)', Icon: #(uIconProject) }
    * print response

    #Read Project
    Given path '/api/projects/' + PROJECT_ID + '.json'
    When method get
    Then status 200
    * match response contains { Content: '#(uContentProject)', Icon: #(uIconProject) }
    * print response

    #Create Item
    Given path '/api/items.json'
    * def cContentItem = "Create Item Karate"
    * def payload =
    """
    {
      "Content": "#(cContentItem)",
      "ProjectId": "#(PROJECT_ID)"
    }
    """
    * request payload
    When method post
    Then status 200
    * print response
    * match response contains { Content: '#(cContentItem)', ProjectId: #(PROJECT_ID) }
    * def ITEM_ID = response.Id
    * print "********** ID **********"
    * print ITEM_ID

    # Update Item
    Given path '/api/items/' +ITEM_ID+ '.json'
    * def uContentItem = "Update Item Karate"
    * def checked = true
    * def payload =
    """
    {
      "Content": "#(uContentItem)",
      "Checked": "#(checked)",
      "ProjectId": "#(PROJECT_ID)"
    }
    """
    * request payload
    When method put
    Then status 200
    * print response
    * match response contains { Content: '#(uContentItem)', Checked: #(checked), ProjectId: #(PROJECT_ID) }

    # Read Item
    Given path '/api/items/' + ITEM_ID + '.json'
    When method get
    Then status 200
    * match response contains { Content: '#(uContentItem)', Checked: #(checked), ProjectId: #(PROJECT_ID) }
    * print response

    # Delete Item
    Given path '/api/items/' + ITEM_ID + '.json'
    * def deletedItem = true
    When method delete
    Then status 200
    * match response contains { Content: '#(uContentItem)', Checked: #(checked), ProjectId: #(PROJECT_ID), Deleted: #(deletedItem) }
    * print response

    #Delete Project
    Given path '/api/projects/' + PROJECT_ID + '.json'
    * def deletedProject = true
    When method delete
    Then status 200
    * match response contains { Content: '#(uContentProject)', Icon: #(uIconProject), Deleted: #(deletedProject) }
    * print response

# 2. Escenarios independientes de Proyecto

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
    Given path '/api/projects/' + projectCreated.projectId + '.json'
    When method get
    Then status 200
    * match response.Content == content
    * call read(deleteProject) { projectId: '#(projectCreated.projectId)' }

  Scenario: Actualizar un proyecto
    # crear proyecto
    * def cContentProject = 'Crear Proyecto'
    * def cIconProject = 1
    * def projectCreated = call read(createProject){ content: '#(cContentProject)', icon: #(cIconProject) }
    * def projectId = projectCreated.projectId
    # actualizar proyecto
    * def content = 'Actualizar Proyecto'
    * def icon = 2
    Given path '/api/projects/' + projectCreated.projectId + '.json'
    * request read('classpath:data/payload.json')
    When method put
    Then status 200
    * match response contains { Content: '#(content)', Icon: #(icon) }
    * call read(deleteProject) { projectId: '#(projectId)' }

  Scenario: Eliminar un proyecto
    # crear proyecto
    * def content = 'Crear Proyecto'
    * def icon = 2
    * def projectCreated = call read(createProject){ content: '#(content)', icon: #(icon) }
    Given path '/api/projects/' + projectCreated.projectId + '.json'
    When method delete
    Then status 200
    * match response contains { Content: '#(content)', Icon: #(icon), Deleted: true }

# 3. Escenarios Independientes de Item

  Scenario: Crear Item de proyecto
      # crear proyecto
    * def cContentProject = 'Create Project Test'
    * def cIconProject = 3
    * def projectCreated = call read(createProject){ content: '#(cContentProject)', icon: #(cIconProject) }
      # crear item
    * def content = 'Create Item Test'
    * def projectId = projectCreated.projectId
    Given path '/api/items.json'
    * request read('classpath:data/payloadItem.json')
    When method post
    Then status 200
    * match response contains { Content: '#(content)', ProjectId: #(projectId) }
    * def itemId = response.Id
      # eliminar item
    * call read(deleteItem) { itemId: '#(itemId)' }
      # eliminar proyecto
    * call read(deleteProject) { projectId: '#(projectId)' }

  Scenario: Leer item de proyecto
      # crear proyecto
    * def cContentProject = 'Create Project Test'
    * def cIconProject = 4
    * def projectCreated = call read(createProject){ content: '#(cContentProject)', icon: #(cIconProject) }
      # crear item
    * def content = 'Create Item Test'
    * def projectId = projectCreated.projectId
    * def itemCreated = call read(createItem) { content: '#(content)', projectId: #(projectId) }
    * def itemId = itemCreated.itemId
      # leer item
    Given path '/api/items/' + itemId + '.json'
    When method get
    Then status 200
    * match response contains { Content: '#(content)', ProjectId: #(projectId) }
      # eliminar item
    * call read(deleteItem) { itemId: '#(itemId)' }
      # eliminar proyecto
    * call read(deleteProject) { projectId: '#(projectId)' }

  Scenario: Actualizar item de proyecto
      # crear proyecto
    * def cContentProject = 'Create Project Test'
    * def cIconProject = 4
    * def projectCreated = call read(createProject){ content: '#(cContentProject)', icon: #(cIconProject) }
      # crear item
    * def cContentItem = 'Create Item Test'
    * def projectId = projectCreated.projectId
    * def itemCreated = call read(createItem) { content: '#(cContentItem)', projectId: #(projectId) }
    * def itemId = itemCreated.itemId
      # actualizar item
    * def content = 'Update Item Test'
    Given path '/api/items/' + itemId + '.json'
    * request read('classpath:data/payloadItem.json')
    When method put
    Then status 200
    * match response contains { Content: '#(content)', ProjectId: #(projectId) }
    * call read(deleteItem) { itemId: '#(itemId)' }
    * call read(deleteProject) { projectId: '#(projectId)' }

  Scenario: Eliminar item de proyecto
      # crear proyecto
    * def cContentProject = 'Create Project Test'
    * def cIconProject = 4
    * def projectCreated = call read(createProject){ content: '#(cContentProject)', icon: #(cIconProject) }
      # crear item
    * def cContentItem = 'Create Item Test'
    * def projectId = projectCreated.projectId
    * def itemCreated = call read(createItem) { content: '#(cContentItem)', projectId: #(projectId) }
    * def itemId = itemCreated.itemId
      # eliminar item
    * def deleted = true
    Given path '/api/items/' + itemId + '.json'
    * request read('classpath:data/payloadItem.json')
    When method delete
    Then status 200
    * match response contains { Content: '#(cContentItem)', ProjectId: #(projectId), Deleted: #(deleted) }
    * call read(deleteProject) { projectId: '#(projectId)' }
