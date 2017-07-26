module FrontRefugesHelper

  def refuges_map_data
    @refuges_all ||= Refuge.all.includes(:country).order(:name).map{ |x| [x.name, x.latitude, x.longitude, x.id, x.city, x.country.name, x.status, x.status_by_entity, (x.primary_contact.nil? ? '' : x.primary_contact.first_name), (x.primary_contact.nil? ? '' : x.primary_contact.phone)] }
  end

  def filtered_refuges_map_data refuges
    @filtered_refuges_all ||= refuges.includes(:country).order(:name).map{ |x| [x.name, x.latitude, x.longitude, x.id, x.city, x.country.name, x.status, x.status_by_entity, (x.primary_contact.nil? ? '' : x.primary_contact.first_name), (x.primary_contact.nil? ? '' : x.primary_contact.phone)] }
  end

  def refuge_class_status refuge
    refuge.good? ? 'refuge-good' : 'refuge-bad'
  end

  def last_updated_date refuge
    refuge.last_questionnaire.nil? ? t("refuges.no_questionnaire_registered") : refuge.last_questionnaire.created_at.strftime("%d/%m/%Y")
  end

  def names_last_six_months
    current_month = Date.today.month
    month_names = 6.downto(1).map { |n| I18n.t DateTime::MONTHNAMES.drop(1)[(current_month - n) % 12] }
  end

  def entities_all
    Entity.first_level
  end

  def set_primary_contact primary_contact
    primary_contact.nil? ? t("refuges.no_primary_contact") : "#{primary_contact.first_name} / Telef: #{primary_contact.phone}"
  end

  def set_refuge_type refuge, locale
    if locale == 'es'
      refuge.refuge_type.nil? ? "No registrado." :  t("refuges.types.refuge_type.#{refuge.refuge_type}")
    else
      refuge.refuge_type.nil? ? "Not registered." :  t("refuges.types.refuge_type.#{refuge.refuge_type}")
    end
  end

  def set_institution_in_charge refuge, locale
    if locale == 'es'
      refuge.institution_in_charge.nil? ? "No registrado." :  t("refuges.types.institution_in_charge.#{refuge.institution_in_charge}")
    else
      refuge.institution_in_charge.nil? ? "Not registered." :  t("refuges.types.institution_in_charge.#{refuge.institution_in_charge}")
    end
  end

  def set_floor_type refuge, locale
    if locale == 'es'
      refuge.floor_type.nil? ? "No registrado." :  t("refuges.types.floor_type.#{refuge.floor_type}")
    else
      refuge.floor_type.nil? ? "Not registered." :  t("refuges.types.floor_type.#{refuge.floor_type}")
    end
  end

  def set_roof_type refuge, locale
    if locale == 'es'
      refuge.roof_type.nil? ? "No registrado." :  t("refuges.types.roof_type.#{refuge.roof_type}")
    else
      refuge.roof_type.nil? ? "Not registered." :  t("refuges.types.roof_type.#{refuge.roof_type}")
    end
  end

  def entity_color entity
    entity = entity.parent.nil? ? entity : entity.parent
    case entity.name
    when 'Alimentos y agua bebible'
      'refuge-food'
    when 'Salud'
      'refuge-health'
    when 'Higiene personal'
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

  def food_management_all
    @food_management ||= FoodManagement.all
  end

  def water_management_all
    @water_management ||= WaterManagement.all
  end

  def light_management_all
    @light_management ||= LightManagement.all
  end

  def stool_management_all
    @stool_management ||= StoolManagement.all
  end

  def waste_management_all
    @waste_management ||= WasteManagement.all
  end

  def hide_sidebar_content_if controller, action
    forbidden_controllers = ["front/refuges/needs/assignments","front/refuges"]
    forbidden_actions = ["show","new"]
    forbidden_controllers.include?(controller) and forbidden_actions.include?(action)
  end

  def date_for_needs_assign start_date, end_date, unique_date
    full_date = unique_date ? "para el #{start_date.strftime("%d/%m/%Y")}." : "entre el #{start_date.strftime("%d/%m/%Y")} y el #{end_date.strftime("%d/%m/%Y")}."
    full_date
  end

end
