class RefugesController < ApplicationController

  before_action :set_refuge, only: :detail

  def index
  end

  def detail
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:id]
  end

end
