class Front::Refuges::NeedsController < FrontController

	before_action :set_refuge, only: :assign
	before_action :set_need, only: :assign

	def assign
	end

	private

	def set_refuge
		@refuge = Refuge.find params[:refuge_id]
	end

	def set_need
		@need = Need.find params[:id]
	end

end