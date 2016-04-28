@javascript
Feature: Groups Tab
  As a College Track staff,
  I want to be able see the list of  groups that I have saved
  I also want to be able to add, update, and delete the groups

Background: Users have been added to the database  

  Given the following users exist:
  | email                   | password |
  | petrduong@gmail.com     | password |
  | jason.chern93@gmail.com | password |
  | shinyenhuang@gmail.com  | password |

  Given the following groups exist for user: "petrduong@gmail.com":
  | name          |   filters                                 |
  | Low GPA       |   2.5 - 3.0,2.0 - 2.5,0.0 - 2.0           |
  | Young         |   9th Grade,10th Grade                    |
  | Old           |   11th Grade,12th Grade                   |

  And I am on the login page
  And I login as "petrduong@gmail.com"

 Scenario: Check to see if the database is reflected
    Given I follow "Groups"
    Then I should see "Low GPA"
    And I should see "Young"
    And I should see "Old"

    When I press the "Young" cell
    And I press the "Year" category
    Then the following filters should be selected: 9th Grade, 10th Grade

    When I press "Cancel"
    Then I should be on the groups index page

 Scenario: Add a Group
    Given I follow "Groups"
    And I press "+"
    Then I should be on the add group page

    When I fill in "Group Name" with "High GPA"
    And I press the "gpa" category
    And I select the filters: 4.0 +, 3.5 - 4.0
    And I press "Save"
    And I wait for a bit
    Then I should be on the groups index page
    And I should see "High GPA"

    When I press the "High GPA" cell
    And I press the "gpa" category
    Then the following filters should be selected: 4.0 +, 3.5 - 4.0

  Scenario: Update a group to include Year
    Given I follow "Groups"
    When I press the "Low GPA" cell
    Then I should be on the edit group page
    And I should see "Low GPA"

    When I press the "Year" category
    And I select the filters: 9th Grade, 10th Grade
    And I press "Save"
    And I wait for a while
    Then I should be on the groups index page

    When I press the "Low GPA" cell
    When I press the "Year" category
    Then the following filters should be selected: 9th Grade, 10th Grade

  Scenario: Delete a group
    Given I follow "Groups"
    When I press the "Young" cell
    Then I should see "Delete"

    When I press "Delete"
    And I wait for a bit
    Then I should be on the groups index page
    And I should not see "Delete"

  Scenario: Add an email to a group
    Given I follow "Groups"
    And I press "+"
    Then I should be on the add group page

    When I fill in "Group Name" with "test"
    When I fill in "Email" with "test@berkeley.edu"
    And I press "Save"
    And I wait for a bit
    Then I should be on the groups index page
    And I should see "test"

