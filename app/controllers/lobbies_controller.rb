class LobbiesController < ApplicationController
  before_action :signed_in?
  before_action ->(options = :unneeded){with_lobby?(options)}, only: [:new]
  before_action :with_lobby?, except: [:new]

  def new
    @lobby = current_user.build_lobby
    respond_to do |format|
      format.js
    end
  end

  def create
    lobby = current_user.build_lobby(lobby_params)
    if lobby.save
      redirect_to root_path, notice: "lobby created!"
    else
      render "main/index"
    end
  end

  def destroy
    if current_user.owner_lobby?
      Lobby.find_by(id: params[:id]).destroy
    else
      current_user.leave_lobby
    end
    redirect_to root_path
  end

  def update
  end

  private

  def with_lobby?(arg = :need)
    head :ok if arg == :unneeded && has_lobby?
    if arg == :need && !has_lobby?
      flash[:error] = "You have not a lobby"
      redirect_to :back
    end
  end

  def lobby_params
    params.require(:lobby).permit(:name)
  end

end
