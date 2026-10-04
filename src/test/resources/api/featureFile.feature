Feature: Project
  Background: configuration
    * url 'https://todo.ly'
    * configure headers = { 'Content-type': 'application/json', 'Authorization': 'Z2Vhbm1hcmNvcy50YXRhamVAZ21haWwuY29tOlRlc3RpbmdKQiQu' }

  Scenario: Create Project
    #create
    Given path '/api/projects.json'
    * def payload = read('../json/payload.json')
    * request payload
    When method post
    Then status 200