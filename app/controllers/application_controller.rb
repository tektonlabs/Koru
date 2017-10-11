# /* 

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_controller, :set_action

  def set_controller
    @controller = params[:controller]
  end

  def set_action
    @action = action_name
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource)
    admin_root_path
  end

end
