When /^I select the (?:following )?filters: (.*)$/ do |filters|
  	filters = filters.split(", ").reject { |f| f == "Student" }
	page.all('#accordian ul li ul li a').each do |link|
	  if filters.include?(link.text)
	    link.click
	  end
  	end
end

When /^I save the filters$/ do
	page.find('#save_filter').click
end

And /^I see the filters: (.*)$/ do |filters|
	filters = filters.split(", ")
	page.all('#accordian ul li ul li a').each do |element|
		element.should be_visible
	end
end

Then /^the following filters should be selected: (.*)$/ do |filters|
	page.all('#accordian ul li ul li a').each do |element|
		if filters.include?(element.text)
			element['class'].should == 'selected'
		end
	end
end

Then /^I should see "(.*)" in the accordian$/ do |item|
	expect(page.find('#accordian')).to have_content(item)
end 

And /^I press the "(.*)" category$/ do |category|
  page.find('#accordian ul li h3', :text => category).click
end
