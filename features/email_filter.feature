@javascript
Feature: Filter students to email by categories

  As a College Track staff,
  So I can send emails to specific groups
  I want to be able to filter through groups of students

Background: Users have been added to the database  

  Given the following users exist:
  | email                   | password |
  | petrduong@gmail.com     | password |
  | jason.chern93@gmail.com | password |
  | shinyenhuang@gmail.com  | password |

  And I am on the login page
  And I login as "petrduong@gmail.com"
  Given I follow "change filters"

Scenario: Add a single filter with default filter selected

  Given I should see "Parent/Student"
  When I press the "Parent/Student" category
  Then the following filters should be selected: Student
  When I press the "gpa" category
  And I select the filters: 3.5 - 4.0
  And I save the filters
  And I wait for a while
  Then the recipient fields should contain: a.thomasadeyemo@gmail.com, asalazar@unityhigh.org
  And the recipient fields should not contain: a.c.perfino@gmail.com, aaronbrowne29@gmail.com

Scenario: Adding multiple filters with existing filters

  Given I press the "High School" category
  And I select the filters: Oakland Technical High School
  And I press the "gpa" category
  And I select the filters: 2.5 - 3.0
  And I save the filters
  And I wait for a while
  Then the recipient fields should not contain: a.c.perfino@gmail.com, aaronbrowne29@gmail.com
  And the recipient fields should contain: habemulu@yahoo.com, juancuriel33@gmail.com

  When I follow "change filters"
  And I press the "Race" category
  And I select the filters: Latino, Multiracial
  And I save the filters
  And I wait for a while
  And the recipient fields should contain: juancuriel33@gmail.com
  And the recipient fields should not contain: habemulu@yahoo.com

Scenario: Removing a single filter through the x button
  Given I press the "High School" category
  And I select the filters: Oakland Technical High School
  And I press the "Race" category
  And I select the filters: Asian
  And I save the filters
  And I wait for a while
  Then the recipient fields should not contain: aaronbrowne29@gmail.com
  
  When I click the x button on "Asian"
  And I wait for a while
  Then the recipient fields should contain: aaronbrowne29@gmail.com

# Scenario: Deselecting filters by changing filters

#   Given I see the filters: Student,Oakland Technical High School,Asian
#   And the recipient fields should contain: amy.huynh123@yahoo.com
#   And I remove the filters: Oakland Technical High School
#   Then the recipient fields should contain: alexfeng420@gmail.com, amyhaunter@gmail.com, huangg.crystal@gmail.com

# Scenario: Filter by university as staff
#   As a College Track staff
#   Given I see the filters: University of Southern California
#   And I add the filters: Stanford
#   Then the recipient fields should contain: darwin.braun@mante.name, marcia@boylezboncak.io

# Scenario: Filter by gender as staff
#   Given I see the filters: Student 
#   And I add the filters: Female
#   Then the recipient fields should contain: abigail.l.2018@lighthousecharter.org, adawkins715@gmail.com

# Scenario: Filter by year as staff
#   As a College Track staff
#   Given I see the filters: sophomore
#   And I add the filters: freshmen
#   Then the recipient fields should contain: darwin.braun@mante.name, mikel.mitchell@oconnell.org

# Scenario: Filter by gender and race
#   Given I see the filters: Student,Female
#   And I add the filters: African American
#   Then the recipient fields should contain: adawkins715@gmail.com, ciaras62@gmail.com
 


# Scenario: Filter by language as staff
#   Given I see the filters: Student
#   And I add the filters: Spanish
#   Then the recipient fields should contain: yasmineflores2013@gmail.com, sand.3401@mail.com

# Scenario: Filter by non-citizens as staff
#   As a College Track staff
#   When I select no citizenship access filter
#   Then I should see student’s emails who aren’t US citizens (illegally documented)

# Scenario: Filter by thresholds as staff
#   As a College Track staff
#   When I select 33 ACT and 3.8 GPA
#   Then I should see only students with these thresholds

# Scenario: Filter by specific groups as staff
#   As a College Track staff
#   When I select Oakland filter
#   Then I should see see student emails that correspond to these centers
