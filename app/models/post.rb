# frozen_string_literal: true

class Post < ApplicationRecord
  extend FriendlyId
  has_many :likes, dependent: :destroy
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :body, presence: true, length: { minimum: 10, maximum: 1500 }
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_rich_text :body
  has_one :content, class_name: 'ActionText::RichText', as: :record, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user
  friendly_id :title, use: %i[slugged history finders]
  belongs_to :category
  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end
end
