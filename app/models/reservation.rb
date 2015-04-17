class Reservation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, type: Date
  field :slot

#  field :guests, type: Integer
#  field :booking_time, type: Time
#  field :user_id
#  field :restaurant_id


  field :table_resources, type: Hash 

end
