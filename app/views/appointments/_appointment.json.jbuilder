json.extract! appointment, :id, :title, :user_id, :start_date, :end_date, :doctor_name, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
