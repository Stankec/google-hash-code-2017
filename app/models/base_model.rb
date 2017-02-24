class BaseModel
  def initialize(attributes = {})
    return if attributes.nil? || !attributes.is_a?(Hash)
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end
end
