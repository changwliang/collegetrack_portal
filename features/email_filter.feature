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

Scenario: Add a single filter with default filter selected

  Given I see the filters: Student
  And I add the filters: Oakland Technical High School
  Then the recipient fields should contain: ae2599@gmail.com, allison.su.truong@gmail.com, yasin1998green@gmail.com

Scenario: Adding multiple filters with existing filters

  Given I see the filters: Student,Oakland Technical High School
  And the recipient fields should contain: ae2599@gmail.com, allison.su.truong@gmail.com, yasin1998green@gmail.com
  And I add the filters: Caucasian
  Then the recipient fields should contain: ambermccutchen1996@gmail.com

Scenario: Removing a single filter through the x button

  Given I see the filters: Student,Oakland Technical High School,Caucasian
  And the recipient fields should contain: ambermccutchen1996@gmail.com
  And I click the x button on "Oakland Technical High School"
  Then the recipient fields should contain: austen.junca@gmail.com, ambermccutchen1996@gmail.com

Scenario: Deselecting filters by changing filters

  Given I see the filters: Student,Oakland Technical High School,Caucasian
  And the recipient fields should contain: ambermccutchen1996@gmail.com
  And I remove the filters: Oakland Technical High School
  Then the recipient fields should contain: austen.junca@gmail.com, ambermccutchen1996@gmail.com

Scenario: Filter by university as staff
  As a College Track staff
  When I select Stanford University as a filter
  Then I should see student’s emails who go to Stanford University

Scenario: Filter by language as staff
  As a College Track staff
  When I select Swahili as the primary language of parents filter
  Then I should see student’s emails that correspond to parents speaking Swahili

Scenario: Filter by non-citizens as staff
  As a College Track staff
  When I select no citizenship access filter
  Then I should see student’s emails who aren’t US citizens (illegally documented)

Scenario: Filter by thresholds as staff
  As a College Track staff
  When I select 33 ACT and 3.8 GPA
  Then I should see only students with these thresholds

Scenario: Filter by specific groups as staff
  As a College Track staff
  When I select Oakland filter
  Then I should see see student emails that correspond to these centers
