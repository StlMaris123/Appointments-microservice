# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  role                   :integer          default(0)
#  phone_number           :string
#  first_name             :string
#  last_name              :string
#  age                    :integer
#  status                 :boolean          default(TRUE)
#  gender                 :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  access_token           :string
#  expires_at             :datetime
#  refresh_token          :string
#
class User < ApplicationRecord
    has_many :appointments, dependent: :destroy
    geocoded_by :address
    after_validation :geocode
end
