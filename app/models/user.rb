# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  surname     :string(255)
#  name        :string(255)
#  middle_name :string(255)
#  birthdate   :date
#  city        :string(255)
#  phone       :string(255)
#  email       :string(255)
#  gender      :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#
require 'active_support'
class User < ActiveRecord::Base
  attr_accessible :birthdate, :city, :email, :gender, :code, :middle_name, :name, :phone, :surname, :image, :password, :password_confirmation
  has_secure_password
  mount_uploader :image, ImageUploader
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_save :create_code
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  validates :name,          presence: true, length: { maximum: 50 }
  validates :surname,       presence: true, length: { maximum: 50 }
  validates :middle_name,   presence: true, length: { maximum: 50 }
  #VALID_DATE_REGEX = /[0-3]?[0-9][0-3]?[0-9](?:[0-9]{2})?[0-9]{2}/
  validates :birthdate, presence: true
#, format: { with: VALID_DATE_REGEX },
                            #uniqueness: { case_sensitive: false }
  validates :city,          presence: true, length: { maximum: 20 }
  VALID_PHONE_REGEX = /(\+38)\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
  validates :phone,         presence: true, format: { with: VALID_PHONE_REGEX }
  validates :gender,           presence: true      
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,         presence: true, format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false }
  validates :password,      presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true


  def self.search(search)
    if search
      find(:all, :conditions => ['code LIKE ?', "%#{search}%"])
    else
      redirect to root_path
    end
  end

   def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  	

  private


    def create_code
      #self.code = rand(36**8).to_s(36)
      self.code = Russian.translit("01" + birthdate.strftime("%d-%m-%Y")[6] + birthdate.strftime("%d-%m-%Y")[7] + birthdate.strftime("%d-%m-%Y")[0] + birthdate.strftime("%d-%m-%Y")[1] + 
                  birthdate.strftime("%d-%m-%Y")[3] + birthdate.strftime("%d-%m-%Y")[4] + birthdate.strftime("%d-%m-%Y")[8] + birthdate.strftime("%d-%m-%Y")[9] + name[0] + surname[0] + 
                  middle_name[0] + Time.now.strftime("%d-%m-%Y")[6] + Time.now.strftime("%d-%m-%Y")[7] + 
                  Time.now.strftime("%d-%m-%Y")[0] + Time.now.strftime("%d-%m-%Y")[1] + 
                  Time.now.strftime("%d-%m-%Y")[3] + Time.now.strftime("%d-%m-%Y")[4] + 
                  Time.now.strftime("%d-%m-%Y")[8] + Time.now.strftime("%d-%m-%Y")[9]  + Time.now.seconds_since_midnight.to_i.to_s + gender[0])
    end

    def create_remember_token 
      self.remember_token = SecureRandom.urlsafe_base64
    end

end


