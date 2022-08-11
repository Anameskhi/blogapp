# frozen_string_literal: true

class User < ApplicationRecord
  after_create :register_customer
  #after_create :register_admin
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :likes, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  pay_customer stripe_attributes: :stripe_attributes

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  has_one_attached :avatar

  mount_uploader :avatar, AvatarUploader
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name # assuming the user model has a name
      # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end


  def update_subscription(value)
    update_attribute :subscribed, value
  end

  def subscribed?
    !!self.subscribed == true
  end

  def stripe_attributes(pay_customer)
    {
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: pay_customer.owner_id
      }
    }
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def register_customer
   request =  Stripe::Customer.create({
      email: email
    })
    
    update_attribute :customer_id, request[:id]
  end

  # def register_admin
  #   if email == "mesxiana3@gmail.com"
  #     update_attribute :admin, true
  #   end
  # end
end
