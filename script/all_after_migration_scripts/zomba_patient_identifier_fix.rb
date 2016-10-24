Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']["database"]

CONN = ActiveRecord::Base.connection

def start
  patients = Encounter.find_by_sql("select patient_id, identifier, date_created from #{Source_db}.patient_identifier pa
                                    where pa.patient_id IN (768, 3174, 3270, 3291, 3519, 4533, 4755, 5067, 7529, 7833, 8192, 9341, 10019, 10034, 11282, 11283, 13862, 14368, 14611, 15588, 15830, 17575, 17851, 19940, 19998, 20313, 20912, 22456, 23126, 26245, 26758, 27211, 27365, 28190, 28525, 28531, 28892, 29710, 30656, 32033, 34851, 35767, 35920, 36818, 41816, 43105, 43336, 44024, 44568, 46998, 50140, 56426, 66841, 70586, 70751, 75733, 75765, 77218, 77958, 81347, 86180, 86761, 90991, 92578, 92661, 103950, 104946, 104957, 122064, 202310)
                                    and pa.identifier_type = 18
                                    and pa.date_created = (select min(date_created) from #{Source_db}.patient_identifier
                                              					   where patient_id = pa.patient_id
                                              					   and identifier_type = pa.identifier_type)
                                    and pa.voided = 1
                                    order by pa.patient_id
                                    limit 5")

  (patients || []).each do |patient|
    puts "working on patient_id: #{patient.patient_id}"
ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.patient_identifier
SET voided = 1,
voided_by = 1,
date_created = '#{patient.date_created}',
void_reason = 'Testing'
WHERE patient_id = #{patient.patient_id}
AND identifier = '#{patient.identifier}'
AND identifier_type = 18
EOF
  end
end

start
