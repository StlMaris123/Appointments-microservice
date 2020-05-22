# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets.rb'

class AppointmentsController < ApplicationController
  CALENDAR_ID = 'primary'
  before_action :set_appointment, only: %i[show edit update destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show; end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit; end

  # POST /appointments
  # POST /appointments.json
  def create
    if @user&.refresh_token.present?
      client = get_google_calendar_client @user
      appointment = params[:appointment]
      event = get_event appointment
      client.insert_event('primary', event)
      flash[:notice] = 'Appointment successfully created'
      redirect_to appointments_path
    else
      none_gmail_users
    end
  end

  def get_google_calendar_client(user)
    client = Google::Apis::CalendarV3::CalendarService.new
    secrets = Google::APIClient::ClientSecrets.new({
                                                     'web' => {
                                                       'access_token' => user&.access_token,
                                                       'refresh_token' => user&.refresh_token,
                                                       'client_id' => ENV['CALENDAR_CLIENT_ID'],
                                                       'client_secret' => ENV['CALENDAR_CLIENT_SECRET']
                                                     }
                                                   })
    begin client.authorization = secrets.to_authorization
          client.authorization.grant_type = 'refresh_token'

          unless user.present?
            client.authorization.refresh_token
            user.update_attributes(
              access_token: client.authorization.access_token,
              refresh_token: client.authorization.refresh_token,
              expires_at: client.authorization.expires_at.to_i
            )
          end
    rescue StandardError => e
      flash[:error] = 'Your token has expired. please relogin with Google'
      redirect_to :back
    end
    client
  end

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: 'Appointment was successfully updated.' }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:title, :user_id, :description, :start_date, :end_date, :doctor_name)
  end

  def none_gmail_users
    @appointment = @user.appointments.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: 'Appointment was successfully created.' }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_event(app)
    app = Google::Apis::CalendarV3::Event.new({
                                               summary: app[:title],
                                               location: request.location,
                                               description: app[:description],
                                               start: {
                                                 date_time: Time.new(app['start_date(1i)'],app['start_date(2i)'],app['start_date(3i)'],app['start_date(4i)'],app['start_date(5i)']).to_datetime.rfc3339,
                                                 time_zone: "Etc/UTC"

                                               },
                                               end: {
                                                 date_time: Time.new(app['end_date(1i)'],app['end_date(2i)'],app['end_date(3i)'],app['end_date(4i)'],app['end_date(5i)']).to_datetime.rfc3339,
                                                 time_zone: "Etc/UTC"
                                               },
                                               
                                               reminders: {
                                                 use_default: false,
                                                 overrides: [
                                                   Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'popup', minutes: 10),
                                                   Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'email', minutes: 1440),
                                                   Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'email', minutes: 30)

                                                 ]
                                               },
                                               notification_settings: {
                                                 notifications: [
                                                   { type: 'event_creation', method: 'email' },
                                                   { type: 'event_change', method: 'email' },
                                                   { type: 'event_cancelation', method: 'email' },
                                                   { type: 'event_response', method: 'email' }
                                                 ]
                                               }, 'primary': true

                                             })
  end
end
