Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]
Destination_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
  @bart1_current_location_id = Patient.find_by_sql("SELECT property_value
                                                     FROM #{Source_db}.global_property
                                                     WHERE property = 'current_health_center_id'").map(&:property_value).first
  
  @bart1_current_location_name = Patient.find_by_sql("SELECT name
                                                     FROM #{Source_db}.location
                                                     WHERE location_id = #{@bart1_current_location_id}").map(&:name).first

  @bart2_current_location_id = Location.find_by_name(@bart1_current_location_name).location_id
  
  update_current_location_id = "UPDATE #{Destination_db}.global_property
                  SET property_value = #{@bart2_current_location_id}
                  WHERE property = 'current_health_center_id'"
                  
    CONN.execute update_current_location_id
    
    update_current_location_name = "UPDATE #{Destination_db}.global_property
                  SET property_value = '#{@bart1_current_location_name}'
                  WHERE property = 'current_health_center_name'"

    CONN.execute update_current_location_name
end

start
