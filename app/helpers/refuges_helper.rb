module RefugesHelper

  def refuges_all
    @refuges_all ||= Refuge.all.order(:name)
  end

  def refuges_map_data
    refuges_all.map{ |x| [x.name, x.latitude, x.longitude] }
  end

  def refuge_class_status refuge
    refuge.good? ? 'refuge-good' : 'refuge-bad'
  end

  def last_updated_date refuge
    refuge.last_questionnaire.nil? ? 'No questionnaire has been registered' : refuge.last_questionnaire.created_at.strftime("%d/%m/%Y")
  end

  def names_last_six_months
    current_month = Date.today.month
    month_names = 6.downto(1).map { |n| DateTime::MONTHNAMES.drop(1)[(current_month - n) % 12] }
  end

  def entities_all
    Entity.first_level
  end

  def refuge_color refuge
    case refuge.name
    when 'Alimentos y agua bebible'
      'refuge-food'
    when 'Salud'
      'refuge-health'
    when 'Higiene Personal'
      'refuge-personal-hygiene'
    when 'Limpieza'
      'refuge-cleaning'
    when 'Electricidad'
      'refuge-electricity'
    when 'Agua'
      'refuge-water'
    when 'Gestión de residuos sólidos'
      'refuge-solid-waste'
    when 'Seguridad'
      'refuge-security'
    end
  end

end
