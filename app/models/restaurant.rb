class Restaurant

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :phone_number, type: String
  field :address
  field :cuisines
  field :cost_for_two, type: Integer

  # facilities will include Serves Alcohol, Parking Available, Serves Non Vegetarian etc.  
  field :facilities, type: Array

  field :outdoor_dining

  field :opening_time, type: Time
  field :closing_time, type: Time
  field :advance_booking_period, type: Integer  
  field :down_time, type: Range
  field :slots, type: Hash

  # { table_capacity, units, minimum_seating_capacity@peak_slot, minimum seating_capacity@regular_slot }
  field :total_table_resources, type: Hash  

end


