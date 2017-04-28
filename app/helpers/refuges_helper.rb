module RefugesHelper

  def refuges_all
    @refuges_all ||= Refuge.all
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
