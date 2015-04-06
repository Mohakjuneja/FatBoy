class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Date
  field :guests, type: Integer
  field :table_resources, type: Hash 

end
