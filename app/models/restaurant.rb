class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :address, type: String
  field :cuisines, type: Array
  field :total_table_resources, type: Hash
  field :opening_time, type: Time
  field :closing_time, Time
  field :phone_number, type: String


end
