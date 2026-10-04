Feature: createProjectData

  # Parámetros de entrada: content, icon
  # Parámetros de salida: projectId, project

  Scenario: Crear proyecto
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    * def payload = read('classpath:data/payload.json')
    Given path '/api/projects.json'
    * request payload
    When method post
    Then status 200
    * match response.ErrorCode == '#notpresent'
    * def project = response
    * def projectId = response.Id