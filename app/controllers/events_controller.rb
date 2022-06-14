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
      location = @event.location
      country = @itinerary.destination
      @event.location = "#{location} #{country}"
      # Call mapbox api for address
      if @event.valid?
        endpoint = 'mapbox.places'
        longitude = @event.longitude
        latitude = @event.latitude
        url = "https://api.mapbox.com/geocoding/v5/#{endpoint}/#{longitude},#{latitude}.json?access_token=pk.eyJ1IjoiZ2VybWFpbmV3b25nZyIsImEiOiJjbDM4Y29vMngwMDlvM2ltZ3Eza3A0ano4In0.pI8jmt7xFxWsty2RwV2XLw"

        mapbox_call = URI.open(url).read
        address = JSON.parse(mapbox_call)['features'][1]['place_name'];
        @event.address = address
      end
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
