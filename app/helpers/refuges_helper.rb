module RefugesHelper

  def refuges_all
    @refuges_all ||= Refuge.all
  end

  def refuge_locations
    @refuge_locations ||= Gmaps4rails.build_markers(refuges_all) do |refuge, marker|
      marker.lat refuge.latitude
      marker.lng refuge.longitude
    end
  end

end
