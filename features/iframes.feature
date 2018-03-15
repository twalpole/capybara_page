Feature: IFrame interaction

  Scenario: locate an iframe by id
    When I navigate to the home page
    Then I can locate the iframe by id

  Scenario: locate an iframe by index
    When I navigate to the home page
    Then I can locate the iframe by index
    And I can see elements in an indexed iframe

  Scenario: locate an iframe by name
    When I navigate to the home page
    Then I can locate the iframe by name
    And I can see elements in a named iframe

  Scenario: locate an iframe by xpath
    When I navigate to the home page
    Then I can locate the iframe by xpath
    And I can see elements in an xpath iframe

  Scenario: interact with elements in an iframe
    When I navigate to the home page
    Then I can see elements in an iframe
    Then I can see elements in an iframe with capybara query options
    And I can see an expected bit of text
