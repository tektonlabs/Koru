class Api::V1::RefugesController < Api::ApiV1Controller

  before_action :pagination, only: :index

  def index
    refuges = Refuge.search_with(search_params, @limit.to_i, @offset.to_i)
    render json: refuges
  end

  def create
    new_refuge = Refuge.new refuges_params
    new_census_taker = CensusTaker.get_or_initialize census_taker_params[:census_taker]
    new_primary_contact = Contact.get_or_initialize primary_contact_params[:primary_contact]
    new_refuge.census_taker = new_census_taker
    new_refuge.primary_contact = new_primary_contact
    new_refuge.secondary_contacts = secondary_contacts_params[:secondary_contacts].map{ |x| Contact.get_or_initialize(x) }
    if new_refuge.save
      render json: { success: true }
    else
      response_error_json_format ErrorResponse.record_not_saved(new_refuge)
    end
  end

  def multiple_choice_ids
    sql = "select refuge_resources.id, refuge_resources.name, tableoid::regclass::text as table_name from refuge_resources"
    results = ActiveRecord::Base.connection.execute(sql)
    render json: results.as_json.group_by{ |x| x["table_name"] }
  end

  private

  def pagination
    @limit = params[:limit] || 15
    @offset = params[:offset] || 0
  end

  private

  def search_params
    params.permit(:query, :lat, :long)
  end

  def refuges_params
    params.permit(:name, :latitude, :longitude, :address, :city, :country_id, :refuge_type, :institution_in_charge, :emergency_type, :property_type, :accessibility, :victims_provenance, :floor_type, :roof_type, :number_of_families, :number_of_people, :number_of_pregnant_women, :number_of_children_under_3, :number_of_older_adults, :number_of_people_with_disabilities, :number_of_pets, :number_of_farm_animals, :number_of_carp, :number_of_toilets, :number_of_washbasins, :number_of_showers, :number_of_tanks, :number_of_landfills, :number_of_garbage_collection_points, :committees, refuge_areas_attributes: [:area_id], refuge_committees_attributes: [:committee_id], refuge_food_managements_attributes: [:food_management_id], refuge_housing_statuses_attributes: [:housing_status_id], refuge_light_managements_attributes: [:light_management_id], refuge_services_attributes: [:service_id], refuge_stool_managements_attributes: [:stool_management_id], refuge_waste_managements_attributes: [:waste_management_id], refuge_water_managements_attributes: [:water_management_id])
  end

  def primary_contact_params
    params.permit(primary_contact: [:first_name, :last_name, :phone, :email])
  end

  def secondary_contacts_params
    params.permit(secondary_contacts: [:first_name, :last_name, :phone, :email])
  end

  def census_taker_params
    params.permit(census_taker: [:dni, :phone, :institution])
  end

end
