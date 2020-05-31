# frozen_string_literal: true

# == Schema Information
#
# Table name: appointments
#
#  id          :bigint           not null, primary key
#  title       :string
#  user_id     :bigint           not null
#  start_date  :datetime
#  end_date    :datetime
#  doctor_name :string
#
class Appointment < ApplicationRecord
  belongs_to :user, optional: true
end
