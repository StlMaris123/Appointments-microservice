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
require 'rails_helper'

RSpec.describe Appointment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
