class AccountsController < ApplicationController
  def new
    timezones_file = File.open("lib/assets/timezones.txt").read.split("\n")
    @timezones = timezones_file.map{|x| {:name => x.split("=>")[0], :id => x.split("=>")[1]}}
  end

  def create
    account = Account.create({:name => params[:name], :timezone => params[:timezone]})
    if account
      user = account.users.create(
        {
          :name => params[:name], 
          :email => params[:email], 
          :password => params[:password], 
          :password_confirmation => params[:password]
        })
      if user
        relation = user.user_account_relations.last
        relation.relation_type = "admin"
        relation.save
        session[:user_id] = user.id
        redirect_to '/dashboard'
      else
        flash[:error] = "Invalid user"
        render '/create'
      end
    else
      flash[:error] = "Account name can't be blank"
      render '/create'
    end
  end
end
