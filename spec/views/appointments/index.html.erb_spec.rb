require 'rails_helper'

RSpec.describe "appointments/index", type: :view do
  before(:each) do
    assign(:appointments, [
      Appointment.create!(
        title: "Title",
        user: nil,
        doctor_name: "Doctor Name"
      ),
      Appointment.create!(
        title: "Title",
        user: nil,
        doctor_name: "Doctor Name"
      )
    ])
  end

  it "renders a list of appointments" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Doctor Name".to_s, count: 2
  end
end
