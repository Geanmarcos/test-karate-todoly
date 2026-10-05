Feature: createItemData

  # Parámetros de entrada: content, projectId
  # Parámetros de salida: itemId, item

  Scenario: Crear Item
    * url baseUrl
    * configure headers = { 'Content-type': 'application/json', 'Authorization': '#(basicAuth)' }
    * def payload = read('classpath:data/payloadItem.json')
    Given path '/api/items.json'
    * request payload
    When method post
    Then status 200
    * match response.ErrorCode == '#notpresent'
    * def item = response
    * def itemId = response.Id