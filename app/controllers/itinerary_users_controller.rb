class ItineraryUsersController < ApplicationController
  before_action :find_itinerary_users, only: [:accept, :reject]
  before_action :find_itinerary, only: [:new, :create]

  def accept
    @itinerary_user.status = "accepted"
    @itinerary = @itinerary_user.itinerary
    @itinerary.chatroom.users << @itinerary_user.user
    if @itinerary_user.save
      @itinerary.save
      new_notification_request_status
      redirect_to itinerary_path(@itinerary), notice: "The user is accepted."
    else
      redirect_to itinerary_path(@itinerary), notice: "Failed to accept user"
    end
    authorize @itinerary_user  # look for ItineraryUserPolicy class
  end

  def reject
    @itinerary_user.status = "rejected"
    @itinerary = @itinerary_user.itinerary

    if @itinerary_user.save
      new_notification_request_status
      redirect_to itinerary_path(@itinerary), notice: "The user is rejected."
    else
      redirect_to itinerary_path(@itinerary), notice: "Failed to reject user"
    end

    authorize @itinerary_user  # look for ItineraryUserPolicy class
  end

  def new
    @itinerary_user = ItineraryUser.new
    authorize @itinerary_user
  end

  def create
    @itinerary_user = ItineraryUser.new(itinerary_user_params)
    @itinerary_user.itinerary = @itinerary
    @itinerary_user.user = current_user

    if @itinerary_user.save
      new_notification_pending_user
      redirect_to itinerary_path(@itinerary)
    else
      flash[:alert] = "You can only make a request to join an itinerary once."
      redirect_to itinerary_path(@itinerary)
    end
    authorize @itinerary_user
  end

  private

  def find_itinerary_users
    @itinerary_user = ItineraryUser.find(params[:id])
  end

  def find_itinerary
    @itinerary = Itinerary.find(params[:itinerary_id])
  end

  def find_itinerary_by_assocation
    @itinerary = @itinerary_user.itinerary
  end

  def itinerary_user_params
    params.require(:itinerary_user).permit(:message)
  end

  def new_notification_pending_user
    @notification = Notification.new
    f_name = "#{@itinerary_user.user.first_name} #{@itinerary_user.user.last_name}"
    @notification.content = " has requested to join your itinerary. Click to view"
    @notification.notification_type = "new_pending"
    @notification.user = @itinerary.user # recipient

    notification_initiator = NotificationInitiator.new(
      user: @itinerary_user.user, # initiator
      itinerary: @itinerary
    )


    # @notification.notification_initiator = @itinerary_user.user # initiator
    # @notification.notification_initiator.itinerary = @itinerary
    @notification.itinerary = @itinerary
    if @notification.save
      notification_initiator.notification = @notification
      notification_initiator.notification.save
      ActionCable.server.broadcast(
        "notification-badge-#{@notification.user.id}",
        render_to_string(partial:
        "notifications/badge-number", locals: { user: @itinerary.user})
      )

      ActionCable.server.broadcast(
        "notification-dropdown-#{@notification.user.id}",
        render_to_string(partial: "shared/each-notification-row", locals: { notification: @notification })
      )
    else
      flash[:alert] = "You have already indicated your interest to join the trip."
    end

  end

  def new_notification_request_status
    organiser = @itinerary_user.itinerary.user
    organiser_f_name = "#{organiser.first_name} #{organiser.last_name}"
    @notification = Notification.new
    notification_initiator = NotificationInitiator.new(
      user: organiser, # initiator = organiser
      itinerary: @itinerary
    )
    case @itinerary_user.status
    when "accepted"
      @notification.content = " has accepted your request to join the itinerary. Click to view."
      @notification.notification_type = "request_accepted"
      @notification.user = @itinerary_user.user # recipient = itinerary_user


      @notification.itinerary = @itinerary
    when "rejected"
      organiser = @itinerary_user.itinerary.user
      @notification.content = " has rejected your request to join the itinerary. Click to view."
      @notification.notification_type = "request_rejected"
      @notification.user = @itinerary_user.user
      @notification.itinerary = @itinerary
    end

    if @notification.save
      notification_initiator.notification = @notification
      notification_initiator.save

      # broadcast the badge
      ActionCable.server.broadcast(
        "notification-badge-#{@notification.user.id}",
        render_to_string(partial:
          "notifications/badge-number", locals: { user: @itinerary_user.user}) # display the user's notification count
      )
      ActionCable.server.broadcast(
        "notification-dropdown-#{@notification.user.id}",
        render_to_string(partial: "shared/each-notification-row", locals: { notification: @notification })
      )
      # broadcast the notification
    end
  end
end
