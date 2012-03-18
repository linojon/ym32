class PeopleController < ApplicationController
  respond_to :html #, :json, :datatables
  
  expose(:people) { Person.all } #{ Person.search(params[:search]).paginate(:page => (params[:page] || 1), :per_page=>params[:per_page]) }
  expose(:person)
  
  def create
    person.save
    respond_with person
  end
  
  def update
    person.save
    resond_with person
  end
  
  def destroy
    person.destroy
    respond_with person
  end
end
