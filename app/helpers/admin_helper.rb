module AdminHelper

  def set_census_taker census_taker
    census_taker.nil? ? "No se ha registrado" : census_taker.dni
  end

  def set_city_country refuge
    refuge.city.blank? ? "#{refuge.country.name}" : "#{refuge.city}, #{refuge.country.name}"
  end

  def only_date date
    date.blank? ? "-" : date.strftime("%d/%m/%Y")
  end

  def only_hours hour
    hour.blank? ? "-" : hour.strftime("%H:%M")
  end

  def refuges_all
    @refuges ||= Refuge.all
  end

  def set_contact primary_contact
    primary_contact.nil? ? "No se ha registrado" : "#{primary_contact.first_name}"
  end

  def set_user_questionnaire user
    user.nil? ? 'No se ha registrado' : user.dni
  end

end
