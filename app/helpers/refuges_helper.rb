module RefugesHelper

  def refuges_all
    @refuges_all ||= Refuge.all
  end

end
