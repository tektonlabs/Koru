class RefugesController < ApplicationController

  def index
  end

  def detail
    @refuge = Refuge.find params[:id]
    ap 'hola me llamo jorgito'
  end

end
