json.extract! job, :id, :summary, :description, :duration, :user_id, :created_at, :updated_at
json.url job_url(job, format: :json)
