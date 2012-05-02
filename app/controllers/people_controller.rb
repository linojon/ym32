class PeopleController < ApplicationController
  before_filter :authorize
  
  respond_to :html #, :json, :datatables
  
  expose(:people) { Person.sorted params[:sort] }
    #{ Person.search(params[:search]).paginate(:page => (params[:page] || 1), :per_page=>params[:per_page]) }
  
  expose(:person)
  
  def create
    if person.save
      flash[:notice] = 'Person was successfully created.' 
      redirect_to people_path
    else
      flash[:error] = 'Person could not be saved. Please check your input.'
      respond_with person
    end
  end

  def update
    if person.update_attributes(params[:person])  
      flash[:notice] = 'Person was successfully updated.'
      redirect_to people_path
    else
      flash[:error] = 'Person could not be saved. Please check your input.'
      respond_with person 
    end  
  end  

  def destroy
    person.destroy
    flash[:notice] = 'Person was successfully deleted.'
    redirect_to people_path
  end
end
