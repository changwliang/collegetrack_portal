module SalesforceClient
  extend ActiveSupport::Concern

  cattr_accessor :client

  def connect_salesforce
    # :cache => Rails.cache, 
    self.client = Restforce.new :host => "login.salesforce.com", 
      :password => ENV['SALESFORCE_PASSWORD'], 
      :security_token => ENV['SALESFORCE_SECURITY_TOKEN']
    self.client.authenticate!
  end

  def generate_email(filters)
    return "" unless filters
    # Set default options
    options = ["Site__c = 'Oakland'",
               "RecordType.Name = 'CT High School Student'",
               "Status__c = 'Youth is currently a student with CT'"]

    # Set Student/Parent filter options
    emailFields = grab_email(filters.delete("Parent/Student"))
    options << "(" + emailFields.map { |v| "#{v} != null" }.join(' OR ') + ")"
    session_options = []
    filter_options = []
    
    # Set Additional Options
    filters.each do |category, values|
      puts "category: " + category.to_s
      if category == "GPA"
        filter_options << "UC_GPA__c != null"
        # Set GPA filter options
        gpa_query = []
        values.each do |range|
          lowerRange = range[0..3].to_f
          # puts "lower range: " + lowerRange.to_s
          if lowerRange == 4.0
            gpa_query << "UC_GPA__c >= 4.0"
            # puts "gpa_query: " + gpa_query.to_s
          else
            upperRange = range[6..-1].to_f
            # puts "lower range: " + lowerRange.to_s + " upper range: " + upperRange.to_s
            gpa_query << "(UC_GPA__c >= #{lowerRange} AND UC_GPA__c <= #{upperRange})"
            
            # puts "gpa_query: " + gpa_query.to_s
          end
          filter_options << "(" + gpa_query.join(' OR ') + ")"
          # puts "options: " + options.to_s
        end
      elsif category == "Workshops"
        values.each do |v|
          session_options << "Workshop__r.Name = '#{v}'"
        end
      else
        query_key = get_column(category)
        group = values.map {|v| "'#{v}'"}.join(', ')
        filter_options << "#{query_key} IN (#{group})"
      end
    end

    # Join all options as a String and request to Salesforce
    query = options.join(' AND ')
    puts "query: " + query
    filter_query = filter_options.join(' AND ')
    puts "filter query: " + filter_query
    workshop_query = session_options.join(' OR ')
    puts "workshop query: " + workshop_query
    if filter_options != [] and session_options == []
      puts "filter not empty, session empty"
      query_string = "SELECT #{emailFields.join(', ')}
                   FROM Contact 
                  WHERE #{query} AND #{filter_query}"
    elsif filter_options == [] and session_options != []
      puts "filter empty, session not empty"
      workshop_response = self.client.query("SELECT Student__c FROM Workshop_Enrollment__c WHERE Workshop__r.Name != null AND (#{workshop_query})").map(&:Student__c)
      
      puts "session student IDs: " + workshop_query
      id_list = workshop_response.map {|v| "'#{v}'"}.join(', ')
      puts "id list: " + id_list.to_s
      query_string = "SELECT #{emailFields.join(', ')}
                   FROM Contact 
                  WHERE #{query} AND (Contact.Id != null AND Contact.Id IN (#{id_list}))"
    elsif filter_options != [] and session_options != []
      puts "filter not empty, session not empty"
      workshop_response = self.client.query("SELECT Student__c FROM Workshop_Enrollment__c WHERE Workshop__r.Name != null AND (#{workshop_query})").map(&:Student__c)
      id_list = workshop_response.map {|v| "'#{v}'"}.join(', ')
      query_string = "SELECT #{emailFields.join(', ')}
                   FROM Contact 
                  WHERE #{query} AND (#{filter_query} OR (Contact.Id != null AND Contact.Id IN (#{id_list})))"
    else
      puts "both empty"
      query_string = "SELECT #{emailFields.join(', ')}
                   FROM Contact 
                  WHERE #{query}"
    end
    puts "query: " + query_string
    response = self.client.query(query_string)

    
    # query = options.join(' AND ')
    # # Query for workshop sessions if exists
    # response2 = nil
    # if session_options != []
    #   workshop_query = session_options.join(" OR ")
    #   workshop_response = self.client.query("SELECT Student__c FROM Workshop_Enrollment__c WHERE Workshop__r.Name != null AND (#{workshop_query})").map(&:Student__c)
    #   id_list = workshop_response.map {|v| "'#{v}'"}.join(', ')
    #   response = client.query("SELECT #{emailFields.join(', ')} FROM Contact WHERE #{query}")
    #   response2 = (client.query("SELECT #{emailFields.join(', ')} FROM Contact WHERE (Contact.Id != null AND Contact.Id IN (#{id_list}))"))
    # else
    #   response = self.client.query("SELECT #{emailFields.join(', ')}
    #                FROM Contact 
    #               WHERE #{query}")
    # end

    # Extract emails according to Student/Parent filter values
    result = emailFields.flat_map do |field|
      response.map(&field.intern).compact
    end.sort { |x,y| y <=> x }
    # if response2 != nil
    #   result2 = emailFields.flat_map do |field|
    #     response2.map(&field.intern).compact
    #   end
    #   result.concat(result2)
    # end
    # result.sort { |x,y| y <=> x }
    # result
  end

  def get_filter_values
    races = get_values("Race__c")
    genders = get_values("Gender__c")
    years = ["12th Grade",
             "11th Grade",
             "10th Grade",
             "9th Grade",
             "Not started high school"].sort_by { |x| x[/\d+/].to_i }
    high_schools = client.query("SELECT High_School__r.Name FROM Contact
                                  WHERE Site__c = 'Oakland' AND 
                                  RecordType.Name = 'CT High School Student' AND 
                                  High_School__r.Name != null 
                                 GROUP BY High_School__r.Name").map(&:Name)
    gpa = ["4.0 +", "3.5 - 4.0", "3.0 - 3.5", "2.5 - 3.0", "2.0 - 2.5", "0.0 - 2.0"]
    parent_student = ["Student", "Parent"]
    language = get_values('Primary_Home_Language__c')
    stem = get_values("STEM__c")
    citizenship = get_values("Citizen__c")
    workshops = client.query("SELECT Workshop__r.Name FROM Workshop_Enrollment__c WHERE Workshop__r.Name != null GROUP BY Workshop__r.Name").map(&:Name)
    {"Parent/Student" => parent_student, "Race" => races, "Gender" => genders, "Year" => years, "Language" => language, "Stem" => stem, "GPA" => gpa, "High School" => high_schools, "Citizenship" => citizenship, "Workshops" => workshops}
  end

  def get_values(column)
    command = "SELECT #{column} FROM Contact 
                WHERE #{column} != null AND 
                RecordType.Name = 'CT High School Student' 
               GROUP BY #{column}"
    # column.intern.to_proc generates block of object
    values = self.client.query(command).map(&column.intern)
  end

  def get_column(category)
    case category
    when "Race"
      "Race__c"
    when "Gender"
      "Gender__c"
    when "Year"
      "Class_Level__c"
    when "High School"
      "High_School__r.Name"
    when "Language"
      "Primary_Home_Language__c"
    when "stem"
      "STEM__c"
    when "GPA"
      "UC_GPA__c"
    when "Citizenship"
      "Citizen__c"
    when "Workshop"
      "Workshop__r.Name"
    else
    end
  end

  def grab_email(values)
    # check if the values are nil
    return "" if values.blank?

    values.flat_map do |v|
      if v.eql? "Student"
        "Email"
      elsif v.eql? "Parent"
        ["Parent_Guardian_Email_1__c", "Parent_Guardian_Email_2__c"]
      end
    end
  end
end