class FirstJob < ApplicationJob
  queue_as :default

  def perform(*args)
    user = User.find(args.first)
    user.subscribed = false
    user.save!
    
  end
end
