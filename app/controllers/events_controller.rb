class EventsController < ApplicationController
  before_action :set_itinerary
  def new
    @event = Event.new
    authorize @event

    # navbar styles
    @banner_navbar = false
    @static_navbar = true
  end

  def create
    Event.transaction do
      @event = Event.new(event_params)
      @event.itinerary = @itinerary

      # Call mapbox api for address
      @event.save!
      redirect_to itinerary_path(@itinerary)
    end
    authorize @event
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def set_itinerary
    @itinerary = Itinerary.find(params[:itinerary_id])
  end

  def event_params
    params.require(:event).permit(:description, :date_start, :date_end, :cost, :location, :title, :photo)
  end

end
