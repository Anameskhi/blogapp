class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer

    @checkout_session1 = current_user
    .payment_processor
    .checkout(
      mode: 'subscription',
      line_items: 'price_1LTLxTECxLULtX2rjzXWoKW7',
      success_url: checkout_success_url,
    )

    @checkout_session2 = current_user
    .payment_processor
    .checkout(
      mode: 'subscription',
      line_items: 'price_1LTM1zECxLULtX2rNIssT5r1',
      success_url: checkout_success_url,
    )

    @checkout_session3 = current_user
    .payment_processor
    .checkout(
      mode: 'subscription',
      line_items: 'price_1LTM2mECxLULtX2r2lnGGU1v',
      success_url: checkout_success_url,
      )
  end

  def success
    if params['session_id'].nil?
      redirect_to root_path
    else
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @subscription = Stripe::Subscription.retrieve(@session['subscription']);    
    end
    
    unless current_user.pay_customers.first.processor_id  ==  @subscription["customer"] && @subscription['plan']['active'] == true && Time.now < Time.at(@subscription['current_period_end']).to_datetime
      redirect_to root_path, notice: t("you_are_already_vip")
    else
      current_user.subscribed = true
      current_user.save!
      redirect_to premium_posts_path, notice: t("subscription_success")
   end
    # @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
  end
end