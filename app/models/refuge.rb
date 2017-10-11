# /* 

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

class Refuge < ApplicationRecord

  validates :name, :latitude, :longitude, :address, :country_id, presence: true
  # validates :number_of_families, :number_of_people, :number_of_pregnant_women, :number_of_children_under_3, :number_of_older_adults, :number_of_people_with_disabilities, :number_of_pets, :number_of_farm_animals, :number_of_carp, :number_of_toilets, :number_of_washbasins, :number_of_showers, :number_of_tanks, :number_of_landfills, :number_of_garbage_collection_points, numericality: { only_integer: true }

  belongs_to :country
  belongs_to :census_taker
  has_one :primary_refuge_contact, -> { where contact_type: :primary }, class_name: "RefugeContact", dependent: :destroy
  has_one :primary_contact, through: :primary_refuge_contact, source: :contact
  has_many :secondary_refuge_contacts, -> { where contact_type: :secondary }, class_name: "RefugeContact", dependent: :destroy
  has_many :secondary_contacts, through: :secondary_refuge_contacts, source: :contact
  has_many :questionnaires, dependent: :destroy
  has_many :refuge_entities, dependent: :destroy
  has_many :entities, through: :refuge_entities
  has_many :refuge_questions, dependent: :destroy
  has_many :questions, through: :refuge_questions
  has_many :refuge_areas, dependent: :destroy
  has_many :areas, through: :refuge_areas
  has_many :refuge_committees, dependent: :destroy
  has_many :committees, through: :refuge_committees
  has_many :refuge_food_managements, dependent: :destroy
  has_many :food_managements, through: :refuge_food_managements
  has_many :refuge_housing_statuses, dependent: :destroy
  has_many :housing_statuses, through: :refuge_housing_statuses
  has_many :refuge_light_managements, dependent: :destroy
  has_many :light_managements, through: :refuge_light_managements
  has_many :refuge_services, dependent: :destroy
  has_many :services, through: :refuge_services
  has_many :refuge_stool_managements, dependent: :destroy
  has_many :stool_managements, through: :refuge_stool_managements
  has_many :refuge_waste_managements, dependent: :destroy
  has_many :waste_managements, through: :refuge_waste_managements
  has_many :refuge_water_managements, dependent: :destroy
  has_many :water_managements, through: :refuge_water_managements

  accepts_nested_attributes_for :refuge_areas
  accepts_nested_attributes_for :refuge_committees
  accepts_nested_attributes_for :refuge_food_managements
  accepts_nested_attributes_for :refuge_housing_statuses
  accepts_nested_attributes_for :refuge_light_managements
  accepts_nested_attributes_for :refuge_services
  accepts_nested_attributes_for :refuge_stool_managements
  accepts_nested_attributes_for :refuge_waste_managements
  accepts_nested_attributes_for :refuge_water_managements
  accepts_nested_attributes_for :primary_contact
  accepts_nested_attributes_for :secondary_contacts

  enum status: [:good, :bad]
  enum refuge_type: [:open_tents, :school, :church, :other]
  enum emergency_type: [:earthquake, :cold_frosty, :landslide_overflow_river, :health_emergency, :fire]
  enum institution_in_charge: [:central_government, :regional_government, :church_institution, :municipality, :community_organization, :non_governmental_organization, :other_institution]
  enum property_type: [:private_property, :public_property, :highways]
  enum accessibility: [:on_foot, :only_4x4, :vehicular]
  enum victims_provenance: [:same_community, :different_communities]
  enum floor_type: [:asphalted, :unpaved]
  enum roof_type: [:outdoors, :roofing]

  after_create :adding_questions_and_entities

  def self.search search_params
    self.search_by_query(search_params[:query]).
      search_by_dni(search_params[:dni])
  end

  def self.search_with search_params, limit, offset
    results = search_by_query(search_params[:query])
    if search_params[:lat].present? and search_params[:long].present?
      results.order_by_distance(search_params[:lat], search_params[:long]).drop(offset).first(limit)
    else
      results.order(:name).limit(limit).offset(offset)
    end
  end

  def self.search_by_query query
    if query.present?
      joins(:country).where("refuges.name ILIKE ? OR refuges.city ILIKE ? OR refuges.address ILIKE ? OR countries.name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end

  def self.search_by_dni dni
    if dni.present?
      joins(:census_taker).where("census_takers.dni = ?", dni)
    else
      all
    end
  end

  def self.order_by_distance lat, long
    self.all.sort_by{ |refuge| refuge.distance_from [lat,long] }
  end

  def has_issues?
    self.last_questionnaire.needs.count != 0 ? true : false
  end

  def last_questionnaire
    self.questionnaires.empty? ? nil : self.questionnaires.order(:state_date).last
  end

  def last_2_questionnaires
    self.questionnaires.empty? ? nil : self.questionnaires.order(:state_date).last(2)
  end

  def observation_responses
    self.last_questionnaire.nil? ? nil : self.last_questionnaire.responses.joins(:question).where('questions.question_type = 2 AND questions.text != ? AND questions.text != ?', '¿Por qué?', '¿Quién es el encargado del recojo de basura?')
  end

  def set_status
    self.refuge_entities.sum(:issues_number) == 0 ? self.good! : self.bad!
  end

  def distance_from location
    lat = location[0].to_f
    long = location[1].to_f
    rad_per_deg = Math::PI/180
    earth_radius_km = 6370
    radio_meters = earth_radius_km * 1000
    latitude_radius_delta = (self.latitude.to_f - lat) * rad_per_deg
    longitude_radius_delta = (self.longitude.to_f - long) * rad_per_deg
    lat1_rad, lon1_rad = [lat, long].map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = [self.latitude.to_f, self.longitude.to_f].map {|i| i * rad_per_deg }
    a = Math.sin(latitude_radius_delta/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(longitude_radius_delta/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    radio_meters * c
  end

  def set_last_six_statuses
    results = []
    current_month = Date.today.month
    month_names = 6.downto(1).map { |n| DateTime::MONTHNAMES.drop(1)[(current_month - n) % 12] }
    month_names.each do |month|
      results << self.monthly_issues(month)
    end
    results
  end

  def monthly_issues month
    start_date = month.to_datetime
    end_date = month.to_datetime.end_of_month
    questionnaires = self.questionnaires
    monthly_questionnaires = questionnaires.where("state_date >= ? and state_date <= ?", start_date, end_date)
    total_issues = 0
    monthly_questionnaires.each do |questionnaire|
      total_issues += questionnaire.needs.count
    end
    monthly_questionnaires.count == 0 ? total_issues : (total_issues / monthly_questionnaires.count.to_f).round(2)
  end

  def set_last_six_statuses_by_entity entity_id
    results = []
    current_month = Date.today.month
    month_names = 6.downto(1).map { |n| DateTime::MONTHNAMES.drop(1)[(current_month - n) % 12] }
    month_names.each do |month|
      results << self.monthly_issues_by_entity(month, entity_id)
    end
    results
  end

  def monthly_issues_by_entity month, entity_id
    start_date = month.to_datetime
    end_date = month.to_datetime.end_of_month
    questionnaires = self.questionnaires
    monthly_questionnaires = questionnaires.where("state_date >= ? and state_date <= ?", start_date, end_date)
    total_issues = 0
    monthly_questionnaires.each do |questionnaire|
      total_issues += questionnaire.needs.where(entity_id: entity_id).count
    end
    monthly_questionnaires.count == 0 ? total_issues : (total_issues / monthly_questionnaires.count.to_f).round(2)
  end

  def self.filter_by_entity entity_id = nil, query = nil
    refuges = Refuge.all
    unless entity_id.nil?
      refuge_entities = RefugeEntity.where("entity_id IN (?) AND issues_number != 0", entity_id)
      refuges = Refuge.where(id: refuge_entities.map(&:refuge_id))
      refuges
    else
      refuges
    end
    unless query.nil?
      refuges.joins(:country).where("refuges.name ILIKE ? OR refuges.city ILIKE ? OR refuges.address ILIKE ? OR countries.name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    else
      refuges
    end
  end

  def send_summary_email
    RefugeMailer.send_summary(self).deliver_later unless self.primary_contact.nil?
  end

  def adding_questions_and_entities
    Entity.first_level.each do |entity|
      RefugeEntity.create refuge: self, entity: entity
    end
    Question.all.each do |question|
      RefugeQuestion.create refuge: self, question: question
    end
  end

  def status_by_entity
    self.refuge_entities.includes(:entity).group_by{|x| x.entity.name}.map{|entity_name, refuge_entities| [entity_name, refuge_entities.inject(0){|total, refuge_entity| total + refuge_entity.issues_number}]}
  end

  def assign_style_class entity
    self.send("#{entity.class.name.underscore.pluralize}").include?(entity) ? "circle-green" : "circle-red"
  end

  def data_for_questionaire_pdf
    questionnaire = self.last_questionnaire
    question_ids = questionnaire.responses.map(&:question_id)
    Question.all.each do |question|
      questionnaire.responses.build question: question if !question_ids.include?(question.id)
    end
    return questionnaire.responses.sort_by{|x| x.question_id}.group_by{|x| (x.question.entity.second_level? ? x.question.entity.parent : x.question.entity)}
  end

end
