class Admin::UsersController < AdminController

  def index
    @users = User.search(search_params).includes(:questionnaires).order(:dni).paginate(per_page: 25, page: params[:page])
  end

  private

  def search_params
    params.permit(:dni)
  end

end
