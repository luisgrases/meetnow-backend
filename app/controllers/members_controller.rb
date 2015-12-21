class MembersController < ApplicationController
  def create
    @member = Member.new(params[:member])
    if @member.save
      puts "Successfully created member"
    end
  end
  
end
