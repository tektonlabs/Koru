class Refuge < ApplicationRecord

  validates :name, presence: true

  belongs_to :country
  has_many :questionnaires
  has_many :refuge_entities
  has_many :entities, through: :refuge_entities
  has_many :refuge_questions
  has_many :questions, through: :refuge_questions

  enum status: [:good, :bad]

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

  def self.order_by_distance lat, long
    self.all.sort_by{ |refuge| refuge.distance_from [lat,long] }
  end

  def has_issues?
    self.refuge_entities.pluck(:issues_number).all? {|i| i != 0 }
  end

  def last_questionnaire
    self.questionnaires.empty? ? nil : self.questionnaires.order(:created_at).last
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

end
