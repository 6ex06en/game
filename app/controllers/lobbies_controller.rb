class LobbiesController < ApplicationController
  before_action :signed_in?
  before_action ->(options = :unneeded){with_lobby?(options)}, only: [:new, :create]
  before_action :with_lobby?, except: [:new, :create, :join]
  before_action :owner_lobby?, only: [:join]

  def new
    @lobby = current_user.build_lobby
    respond_to do |format|
      format.js
    end
  end

  def create
    lobby = current_user.build_lobby(lobby_params(:create))
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

  def join
    lobby = Lobby.find_by(params[:id])
    if lobby
      lobby.update_attributes(guest_id: params[:guest_id]) 
      redirect_to root_path
    else
      render "main/index"
    end
  end

  private

  def with_lobby?(arg = :need)
    head :ok if arg == :unneeded && has_lobby?
    if arg == :need && !has_lobby?
      flash[:error] = "You have not a lobby"
      redirect_to :back
    end
  end

  def lobby_params(action)
    case action
      when :create then params.require(:lobby).permit(:name)
      when :update then params.permit(:guest_id)
    end
  end
  
  def owner_lobby?
    redirect_to root_path if current_user.owner_lobby?
  end
  

end
