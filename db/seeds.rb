# require 'faker'
# require 'json'
# require 'open-uri'

# puts "Cleaning database..."
# User.destroy_all
# Itinerary.destroy_all
# Event.destroy_all
# ItineraryUser.destroy_all
# ItineraryRestriction.destroy_all
# Restriction.destroy_all
# Announcement.destroy_all
# Notification.destroy_all
# Chatroom.destroy_all
# Message.destroy_all
# UserChatroom.destroy_all

# puts "Creating users..."

# # 10 users
# 50.times do
#   user = User.new(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     age: (1..80).to_a.sample,
#     gender: ["M", "F"].sample,
#     email: Faker::Internet.email,
#     password: "12345678"
#   )
#   user.save!

#   5.times do
#     notification = Notification.new(
#       content: Faker::Quote.yoda,
#     )
#     user.notifications << notification
#     notification.save!
#   end
# end

# users = User.all


# puts "Creating events..."

# LOCATION_STRING = ["10 Bayfront Ave, Singapore 018956", "313 Somerset Road",
#   "53 Ang Mo Kio Avenue 3", "Queen Street", "Seletar Mall", "Tampines Mall",
#   "Changi City Point", "Jewel Airport", "National University of Singapore",
#   "Orchard Gateway", "Nex", "Vivo City", "Bukchon Hanok Traditional Village",
#   "National Museum of Korea", "Lotte World Tower", "Gyeongbokgung Palace",
#   "Bukhansan National Park", "Eiffel Tower", "Louvre Museum", "Palace of Versailles", "Mont Blanc", "Dune du Pilat", "Parc National des Calanques"]


#   # 30 events

# # 10 itineraries
# puts "Creating itineraries..."
# 10.times do
#   # create chatroom that comes with the itinerary
#   chatroom = Chatroom.new(
#     name: Faker::Lorem.word
#   )

#   chatroom.save!

#   random_start_date = Faker::Date.between(from: '2022-05-20', to: '2022-12-28')
#   random_end_date = random_start_date + (3..14).to_a.sample
#   itinerary = Itinerary.new(
#     title: "A great time in #{Faker::Nation.capital_city}",
#     participant_limit: (2..8).to_a.sample,
#     description: Faker::Company.catch_phrase,
#     deadline: random_start_date - (5..10).to_a.sample
#   )

#   # assign organiser
#   random_num = (3..10).to_a.sample
#   interested_users = User.all.sample(random_num)
#   organiser = interested_users.pop # length - 1 due to pop
#   itinerary.user = organiser



#   #assign chatroom to itinerary
#   itinerary.chatroom = chatroom
#   itinerary.save!

#   # assign accepted users to chatroom
#   # accepted_users.each { |person| chatroom.users << person}
#   accepted_user = interested_users.pop
#   pending_users = interested_users # default value of itinerary_user is pending

#   pending_users.each do |person|
#     new = ItineraryUser.new
#     new.itinerary = itinerary
#     new.user = person
#     new.message = Faker::Books::Dune.quote
#     new.save!
#   end

#   # interested_users.each do |person|
#   #   new = ItineraryUser.new
#   #   new.itinerary = itinerary
#   #   new.user = person
#   #   new.save!
#   # end
#   new = ItineraryUser.new
#   new.itinerary = itinerary
#   new.status = "accepted"
#   new.user = accepted_user
#   new.save!

#   itinerary.save!

#   chatroom.users << accepted_user
#   chatroom.users << organiser
#   chatroom.save!

#   # populate chatroom with some messages
#   5.times do
#     message = Message.new(
#       content: Faker::TvShows::StrangerThings.quote
#     )
#     message.chatroom = chatroom
#     message.user = organiser
#     message.save!
#   end

#   # assign itinerary_users
#     # every interested_user thats not organiser is a member





#   3.times do
#     event = Event.new(
#       title: Faker::Mountain.name,
#       description: Faker::Company.catch_phrase,
#       date_start: random_start_date,
#       date_end: random_end_date,
#       location: LOCATION_STRING.sample, # PROBLEM: my location is not a subset of itnerary title now
#       cost: (50..1000).to_a.sample
#     )
#     event.itinerary = itinerary
#     event.save!
#   end

#   5.times do
#     announcement = Announcement.new(
#       content: Faker::TvShows::GameOfThrones.quote
#     )
#     itinerary.announcements << announcement
#     announcement.save!
#   end

# end

# puts "Creating restrictions..."
# # creating itinerary_criteria – 1a) only women 1b) only men 2a) 20-30 y/o 2b) 30-40 y/o 2c) > 40 y/o
# first_restriction = Restriction.new(
#   title: "only women",
#   restricted_gender: "F"
# )
# first_restriction.save!

# second_restriction  = Restriction.new(
#   title: "only men",
#   restricted_gender: "M"
# )
# second_restriction.save!

# third_restriction = Restriction.new(
#   title: "20–30 year olds",
#   min_age: 20,
#   max_age: 30
# )
# third_restriction.save!

# fourth_restriction = Restriction.new(
#   title: "30-40 year olds",
#   min_age: 30,
#   max_age: 40
# )
# fourth_restriction.save!

# fifth_restriction = Restriction.new(
#   title: ">40 year old",
#   min_age: 0,
#   max_age: 40
# )
# fifth_restriction.save!

# # create itinerary_criteria
# Itinerary.all.each do |it|
#   itinerary_restriction = ItineraryRestriction.new
#   itinerary_restriction.description = Faker::Lorem.sentence(word_count: 20)
#   itinerary_restriction.itinerary = it
#   itinerary_restriction.restriction = Restriction.all.sample
#   itinerary_restriction.save!
# end

# puts "Done with all models"


require 'faker'
require 'json'
require 'open-uri'

puts "Cleaning database..."
User.destroy_all
Itinerary.destroy_all
Event.destroy_all
ItineraryUser.destroy_all
ItineraryRestriction.destroy_all
Restriction.destroy_all
Announcement.destroy_all
Notification.destroy_all
Chatroom.destroy_all
Message.destroy_all
UserChatroom.destroy_all

puts "Creating users..."

REQUEST_MESSAGES = ["Please let me join!!!!", \
                    "I would love to join this trip, because there are a lot of like-minded people", \
                    "Sounds like a really well-planned trip! please count me in!", "I'm a huge fan of your itineraries. Please let me join."]

GROUP_CHATROOM_MESSAGES = ["We are going to grab some ramen before the event. Feel free to join us.", \
                          "It seems like it's going to rain... Is the event still on?",\
                          "Hi everyone! I'm super excited for the trip.", \
                          "Hi everyone! Glad to meet all of you. Do remember to bring a jacket as it will be cold",
                          "Anyone has mints?"]

SINGAPORE_LOCATIONS = ["Marina Bay Sands", "Bugis Street", "Changi Jewel", "Sentosa", "Esplanade", "Tampines Mall", "Nex", "Sungei Buloh Wetland Reserve"]

KOREA_LOCATIONS = ["Gyeongbokgung Palace", "N Seoul Tower", "Lotte World", "Everland", "Myeong-Dong", "Haeundae Beach", "Jagalchi Market", "Nami Island", "Korean Folk Village", "Bukhansan"]

COST_ARRAY = [50, 58, 68, 120, 150, 200, 347, 430, 500]

# itinerary.title, itinerary.description

def create_one_itinerary(itinerary_title, itinerary_description, date_start)

  # ––––– USER –––––
  # create users
  current_iti_users = []
  10.times do
    user = User.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name ,
      age: (18..65).to_a.sample,
      gender: ["M","F"].sample,
      email: Faker::Internet.email,
      password: "12345678"
    )
    user.save!
    current_iti_users << user
  end

  # assigning organisers, accepted users and pending users (TODO: assign itinerary_users)
  puts "assigning organisers, accepted users and pending users"
  organiser = current_iti_users.last
  current_iti_users.pop
  accepted_users = current_iti_users.sample(rand(current_iti_users.size)) # choose random number of accepted users

  # remove accepted users from array. Remaining array: pending_users
  accepted_users.each do |accepted_user|
    current_iti_users.delete(accepted_user)
  end

  pending_users = current_iti_users

  # ––––– ITINERARIES –––––
  # itinearies -> must have chatroom & organiser
  itinerary = Itinerary.new(
    title: itinerary_title,
    participant_limit: accepted_users.size + 3,
    description: itinerary_description,
    region: "Singapore",
    finalised: false,
    deadline: Faker::Date.forward(days: 50)
  )

  puts "creating chatroom for current itinerary"
  # ––––– CHATROOM (each chatroom has many messages) –––––
  # chatroom -> assign organiser to chatroom first
  chatroom = Chatroom.new(
    name: itinerary.title
  )

  chatroom.save!

  itinerary.chatroom = chatroom
  itinerary.user = organiser
  itinerary.save! # I should be able to save now

  # --- CREATING ITINERARY USERS ---
  pending_users.each do |p_user|
    itinerary_user = ItineraryUser.new(
      status: "pending",
      message: REQUEST_MESSAGES.sample
    )
    itinerary_user.user = p_user
    itinerary_user.itinerary = itinerary
    itinerary_user.save!
  end

  accepted_users.each do |a_user|
    itinerary_user = ItineraryUser.new(
      status: "accepted",
      message: REQUEST_MESSAGES.sample
    )

    itinerary_user.user = a_user
    itinerary_user.itinerary = itinerary
    itinerary_user.save!

    # adding accepted members to chatroom
    chatroom.users << a_user
    chatroom.save!
  end


  # ––––– MESSAGES –––––
  puts "creating messages within chatroom"
  5.times do
    message = Message.new(
      content: GROUP_CHATROOM_MESSAGES.sample
    )
    message.user = accepted_users.sample
    message.chatroom = chatroom
    message.save!

    chatroom.messages << message
    chatroom.save!
  end

  # save itinerary -> append events to each itinerary

  # ––––– EVENTS (one itinerary has many events) –––––
  # sampled_korea_location = KOREA_LOCATIONS.sample(5)
  # 5.times do
  #   event = Event.new(
  #     cost: COST_ARRAY.sample,
  #     location: sampled_korea_location.sample,
  #     title: "A fabulous time",
  #     date_start: ,
  #     date_end:
  #   )
  # end

  # ––––– ANNOUNCEMENTS (one itinerary has many announcements) –––––
  puts "creating a lame announcement for itinerary"
  announcement = Announcement.new(
    content: "Hello everyone! Really good to have you here"
  )
  announcement.itinerary = itinerary
  announcement.save!

  # ––––– RESTRICTIONS (one itinerary has many restrictions through itinerary_restrictions) –––––

    # ITINERARY_RESTRCTIONS: write a short description

  puts "current itinerary flow completed!"
end

create_one_itinerary(1,2,3,4,5)
