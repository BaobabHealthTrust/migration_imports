CONN = ActiveRecord::Base.connection

def start

  destination = YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]
  identifiers = PatientIdentifier.find_by_sql("SELECT * FROM #{destination}.patient_identifier WHERE  identifier_type= 4 AND voided = 0")

  puts "FOUND #{identifiers.length} ARV NUMBERS"

  (identifiers || []).each do |identifier|

    old_id = identifier.identifier
    site_code,number = old_id.to_s.split(" ")
    unless (site_code.blank? && number.blank?)
      new_identifier = site_code.to_s.squish + "-ARV-" + number.to_s.squish
      update_arv_number = "UPDATE #{destination}.patient_identifier SET identifier = '#{new_identifier}' WHERE patient_identifier_id = #{identifier.patient_identifier_id}"
      CONN.execute update_arv_number
      puts "Old ARV Number: #{old_id} -------- New ARV Number: #{new_identifier}"
    end


  end

end

start