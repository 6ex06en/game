class SessionsController < ApplicationController

  def new
  end

	def create
    user = User.find_by(name: params[:session][:name])
		if user && user.authenticate(params[:session][:password])
      flash.now[:error] = "Welcome, #{user.name}"
      sign_in user
      redirect_to root_path
		else
			flash.now[:error] = 'Invalid email/password combination'
		  render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
