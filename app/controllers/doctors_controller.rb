# frozen_string_literal: true

class DoctorsController < ApplicationController

  def hospitals
    # @client = GooglePlaces::Client.new(ENV['PLACES_API'])
    # @client.spots(@user.latitude, @user&.longitude, :types => 'hospital')
    @client = User.near(@user.address).where(tags: [:hospital]).all
  end
end
