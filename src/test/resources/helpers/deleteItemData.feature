Feature: deleteItemData

    # Parámetros de entrada: itemId

  Scenario: Eliminar item
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    Given path '/api/items/' + itemId + '.json'
    When method delete
    Then status 200
    * match response.Deleted == true