require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^the following groups exist for user: "(.*)":$/ do |user, groups_table|
	user = User.where(:email => user).first
	groups_table.hashes.each do |group|
    	user.groups.create(group)
  	end
end

When /^I press the "(.*)" cell$/ do |text|
	page.find('.cell', :text => text).find(:xpath, "..").click
	
end

When /^I press the "(.*)" button$/ do |text|
  page.find('button', :text => "#{text}").click
end

Then /^I wait for a bit$/ do
	sleep 3
end

When /^I fill in "(.*)" with "(.*)"$/ do |title, value|
	page.find('text', :text => title).find(:xpath, "..").find('input').set value
end





