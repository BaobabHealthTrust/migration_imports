Source_db= YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart2']["database"]

CONN = ActiveRecord::Base.connection

def start
	
  user_person_id = Encounter.find_by_sql(" SELECT person_id
                                         FROM #{Source_db}.users
                                         WHERE username = 'admin'").map(&:person_id).first

  if user_person_id.to_i == 1
    #void person with person_id 1
      ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.person
SET voided = 1, voided_by = 1, date_voided = '#{Date.today}', void_reason = 'there is a patient with id 1'
WHERE person_id = 1
EOF

@person_uuid = Encounter.find_by_sql("SELECT UUID() as uuid").map(&:uuid).first

      ActiveRecord::Base.connection.execute <<EOF
INSERT INTO #{Source_db}.person (date_created, date_changed, creator, uuid)
VALUES ('#{Date.today}', '#{Date.today}', 1, '#{@person_uuid}')
EOF

    #Get the new person_id
@new_person_id = Encounter.find_by_sql("SELECT person_id FROM #{Source_db}.person
                                        WHERE uuid = '#{@person_uuid}'").map(&:person_id).first

  #update person_names
      ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.person_name
SET person_id = #{@new_person_id}
WHERE person_id = 1
EOF

  #update user
      ActiveRecord::Base.connection.execute <<EOF
UPDATE #{Source_db}.users
SET person_id = #{@new_person_id}
WHERE person_id = 1
EOF

  end
end
start
