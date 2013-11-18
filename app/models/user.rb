class User < ActiveRecord::Base
	set_table_name "users"
		set_primary_key :user_id
	belongs_to :person, :foreign_key => :person_id
end
