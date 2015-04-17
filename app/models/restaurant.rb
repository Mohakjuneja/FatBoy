class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :address, type: String
  field :phone_number, type: String
  field :cuisines, type: Array
  field :cost_for_two, Integer

  field :opening_time, type: Time
  field :closing_time, type: Time
  field :advance_booking_period  
  field :down_time, type: Range
  
  field :slots

  field :total_table_resources, type: Hash  
  # {table_capacity, units, minimum_seating_capacity}

end


