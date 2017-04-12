class ErrorResponse
  attr_accessor :title, :reasons, :description, :status_code, :error_code

  def initialize(args)
    @title = args[:title] || "Error"
    @error_code = args[:error_code] || Rack::Utils::SYMBOL_TO_STATUS_CODE[args[:status_code]] || 404
    @reasons = args[:reasons] || { base: "An error has ocurred" }
    @description = args[:description] || "An error has ocurred"
    @status_code = args[:status_code] || :ok
  end

  def to_json
    {
      error: {
        message: title,
        code: error_code,
        reasons: reasons,
        description: description
      }
    }
  end

  def self.record_not_found(model)
    self.new(title: "#{model.capitalize} not found", description: "The #{model} does not exist or you do not have access", status_code: :not_found)
  end

  def self.record_not_saved(record)
    self.new(
      title: "#{record.class.to_s.capitalize} not saved",
      description: "Verify the values",
      reasons: record.errors.full_messages,
      status_code: :unprocessable_entity
    )
  end

  def self.unknown_error error
    self.new(
      title: "An unknown error has ocurred",
      reasons: { base: error.message },
      status_code: :error
    )
  end

  def self.not_found_error error
    self.new(
      title: "Not found",
      reasons: { base: error.message },
      status_code: :not_found
    )
  end

  def self.unauthorized
    self.new(status_code: :unauthorized, title: "You are unauthorized to perform this action")
  end

end