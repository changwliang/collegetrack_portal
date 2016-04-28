@javascript
Feature: Groups Tab
  As a College Track staff,
  I want to be able to use the groups I've made from the email page

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
  | Test          |   3.0 - 3.5                               |

  And I am on the login page
  And I login as "petrduong@gmail.com"
  And I wait for a while

  Scenario:
    Given the recipient fields should contain: 35347@cv.k12.ca.us
    When I follow "change filters"
    Then I should see "Groups" in the accordian

    When I press the "Groups" category
    Then I should see "Low GPA" in the accordian
    And I should see "Young" in the accordian
    And I should see "Old" in the accordian
    And I should see "Test" in the accordian

    When I select the following filters: Test
    And I save the filters
    And I wait for a while
    Then I should see "Test"
    Then the recipient fields should not contain: 35347@cv.k12.ca.us




