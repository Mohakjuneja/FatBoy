class Reservation

  include Mongoid::Document
  include Mongoid::Timestamps


  field :reservation_date, type: Date
  field :reservation_time, type: Time

  field :guests, type: Integer
  field :table_capacity, type: Integer
  field :reservation_honoured, type: Boolean
  field :user_id
  field :restaurant_id
  field :offer_id
  


end
