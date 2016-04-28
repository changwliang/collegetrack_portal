class GroupsController < ApplicationController
  include SalesforceClient
  def index
  	@groups = current_user.groups
  	return
  end

  def edit
  	@filters = params[:filters]
  	@name = params[:name]
  	@group = current_user.groups.where(:name => params[:name], :filters => params[:filters])
    @extra_emails = params[:extra_emails]
  	return
  end

  def add
    return
  end

  def delete
  	name = params[:name]
  	if current_user.groups.exists?(:name => name)
  		group = current_user.groups.where(:name => name).first
  		group.destroy()
  	end
  	redirect_to groups_index_path
  	return
  end


  def create
    extra_emails = params[:extra_emails]
  	name = params[:name]
  	filters = params[:filters]
  	if name and filters
  		if current_user.groups.exists?(:name => name)
  			group = current_user.groups.where(:name => name).first
  			group.filters = filters
        group.extra_emails = extra_emails
  			group.save()
  		else
  			current_user.groups.create!(:name => name, :filters => filters, :extra_emails => extra_emails)
  		end
  		render nothing: true, status: 278
  	else
  		render nothing: true, status: 278
  	end
  end
end
