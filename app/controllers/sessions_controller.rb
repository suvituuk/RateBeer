class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && user.active
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      if not user && user.authenticate(params[:password])
        redirect_to :back, notice: "Username and/or password mismatch"
      else
	redirect_to :back, notice: "Your account is frozen, please contact admin"
      end
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
