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

  def refuge_class_status refuge
    case refuge.status
    when 'good'
      'refuge-good'
    when 'regular'
      'refuge-regular'
    else
      'refuge-bad'
    end
  end

end
