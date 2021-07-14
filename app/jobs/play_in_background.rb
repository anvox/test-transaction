class PlayInBackground
  include Sidekiq::Worker

  sidekiq_retry_in do |_count, _exception|
    10
  end

  def perform(user_id)
    puts "#{'='*100}#{User.find(user_id).name}#{'='*100}"
  end
end
