class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :client_id, :secret

  validates_presence_of :client_id
  validates_presence_of :secret

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def attributes
    {
      client_id: client_id,
      secret: secret
    }
  end
end