class Api::V1::StripeSubscriptionsController < ActionController::API
  def webhook
    webhook_secret = ENV['STRIPE_WEB_HOOK']

    payload = request.body.read
    if !webhook_secret.empty?

      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
     begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, webhook_secret
      )
    rescue JSON::parserError =>
      status 400
    rescue Stripe::SignitureVerificationError
      puts "Webhook verification failed"
      status 400
    end
  else
    data = JSON.parse(payload, symbolize_names: true)
    event = Stripe::Event.construct_from(data)
  end
  # Get the type of webhook event sent
  event = event['type']
  data = event['data']
  data_object = data['object']
    
  user = User.find_by_customer_id(data_object['customer'])

  case event.type
  when 'checkout.session.completed'
  user.update_subscription true
  when 'invoice.paid'
   nil
  when 'invoice.payment_failed'
    user.update_subscription false
  else
    puts "Unhandled event type: #{event.type}"
  end

  render :ok
  end
end
