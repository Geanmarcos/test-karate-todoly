Feature: deleteProjectData

    # Parámetros de entrada: projectId

  Scenario: Eliminar proyecto
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    Given path '/api/projects/' + projectId + '.json'
    When method delete
    Then status 200
    * match response.Deleted == true