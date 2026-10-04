Feature: Project
  Background: configuration
    * url 'https://todo.ly'
    * configure headers = { 'Content-type': 'application/json', 'Authorization': 'Z2Vhbm1hcmNvcy50YXRhamVAZ21haWwuY29tOlRlc3RpbmdKQiQu' }

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