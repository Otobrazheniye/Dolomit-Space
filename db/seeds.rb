Reservation.destroy_all
Room.destroy_all

at = ->(day, hour, minute = 0) do
  Time.zone.local(2026, 9, day, hour, minute)
end


# ============================================================
# ROOMS
# ============================================================

conference_room = Room.create!(name: "Conference Room A", capacity: 3)

meeting_room = Room.create!(name: "Meeting Room B", capacity: 2)

boardroom = Room.create!(name: "Boardroom C", capacity: 4)

edge_case_room = Room.create!(name: "Overlap Test Room", capacity: 5)

focus_room = Room.create!(name: "Focus Room", capacity: 1)


# ============================================================
# CONFERENCE ROOM A
# Capacity: 3
#
# Demonstrates a nearly/full capacity period.
# Between 10:30 and 11:00 -> 3 / 3 reservations.
# ============================================================

Reservation.create!(
  room: conference_room, reserved_by: "Anna",
  start_date: at.call(23, 9, 0),
  end_date: at.call(23, 12, 0)
)

Reservation.create!(
  room: conference_room, reserved_by: "John",
  start_date: at.call(23, 10, 0),
  end_date: at.call(23, 11, 0)
)

Reservation.create!(
  room: conference_room, reserved_by: "Maria",
  start_date: at.call(23, 10, 30),
  end_date: at.call(23, 11, 30)
)

# Starts exactly when Anna's reservation ends.
# This must NOT conflict with Anna.
Reservation.create!(
  room: conference_room, reserved_by: "Olga",
  start_date: at.call(23, 12, 0),
  end_date: at.call(23, 13, 0)
)

Reservation.create!(
  room: conference_room, reserved_by: "Daniel",
  start_date: at.call(23, 13, 0),
  end_date: at.call(23, 14, 30)
)


# ============================================================
# MEETING ROOM B
# Capacity: 2
#
# Demonstrates nested reservations and exact boundaries.
# ============================================================

Reservation.create!(
  room: meeting_room, reserved_by: "Emma",
  start_date: at.call(24, 13, 0),
  end_date: at.call(24, 14, 0)
)

# Starts exactly when Emma finishes.
Reservation.create!(
  room: meeting_room, reserved_by: "Peter",
  start_date: at.call(24, 14, 0),
  end_date: at.call(24, 17, 0)
)

# Fully contained inside Peter's reservation.
Reservation.create!(
  room: meeting_room, reserved_by: "Sofia",
  start_date: at.call(24, 15, 0),
  end_date: at.call(24, 16, 0)
)

# Starts exactly when Peter finishes.
Reservation.create!(
  room: meeting_room, reserved_by: "Alex",
  start_date: at.call(24, 17, 0),
  end_date: at.call(24, 18, 0)
)


# ============================================================
# BOARDROOM C
# Capacity: 4
#
# Demonstrates chained / partially overlapping intervals.
# ============================================================

Reservation.create!(
  room: boardroom, reserved_by: "Liam",
  start_date: at.call(25, 9, 0),
  end_date: at.call(25, 10, 30)
)

Reservation.create!(
  room: boardroom, reserved_by: "Eva",
  start_date: at.call(25, 10, 0),
  end_date: at.call(25, 12, 0)
)

Reservation.create!(
  room: boardroom, reserved_by: "Noah",
  start_date: at.call(25, 11, 0),
  end_date: at.call(25, 13, 0)
)

Reservation.create!(
  room: boardroom, reserved_by: "Mia",
  start_date: at.call(25, 12, 30),
  end_date: at.call(25, 14, 0)
)

Reservation.create!(
  room: boardroom, reserved_by: "Leo",
  start_date: at.call(25, 14, 0),
  end_date: at.call(25, 15, 30)
)


# ============================================================
# OVERLAP TEST ROOM
# Capacity: 5
#
# This room intentionally demonstrates practically every
# important relationship between two time intervals.
# ============================================================

# Base reservation
Reservation.create!(
  room: edge_case_room, reserved_by: "Alice",
  start_date: at.call(26, 10, 0),
  end_date: at.call(26, 12, 0)
)

# Exactly the same interval
Reservation.create!(
  room: edge_case_room, reserved_by: "Bob",
  start_date: at.call(26, 10, 0),
  end_date: at.call(26, 12, 0)
)

# Fully inside another reservation
Reservation.create!(
  room: edge_case_room, reserved_by: "Charlie",
  start_date: at.call(26, 10, 30),
  end_date: at.call(26, 11, 30)
)

# Starts before the base reservation and overlaps its beginning
Reservation.create!(
  room: edge_case_room, reserved_by: "Diana",
  start_date: at.call(26, 9, 0),
  end_date: at.call(26, 10, 30)
)

# Starts inside the base reservation and ends after it
Reservation.create!(
  room: edge_case_room, reserved_by: "Ethan",
  start_date: at.call(26, 11, 30),
  end_date: at.call(26, 13, 0)
)

# Contains the entire base reservation
Reservation.create!(
  room: edge_case_room, reserved_by: "Fiona",
  start_date: at.call(26, 9, 30),
  end_date: at.call(26, 12, 30)
)

# Ends exactly when Diana begins
Reservation.create!(
  room: edge_case_room, reserved_by: "Grace",
  start_date: at.call(26, 8, 0),
  end_date: at.call(26, 9, 0)
)

# Starts exactly when Ethan ends
Reservation.create!(
  room: edge_case_room, reserved_by: "Henry",
  start_date: at.call(26, 13, 0),
  end_date: at.call(26, 14, 0)
)


# ============================================================
# FOCUS ROOM
# Capacity: 1
#
# Demonstrates strict single-reservation capacity.
# Consecutive reservations touching at their boundaries
# are allowed.
# ============================================================

Reservation.create!(
  room: focus_room, reserved_by: "Laura",
  start_date: at.call(27, 9, 0),
  end_date: at.call(27, 10, 0)
)

Reservation.create!(
  room: focus_room, reserved_by: "Martin",
  start_date: at.call(27, 10, 0),
  end_date: at.call(27, 11, 0)
)

Reservation.create!(
  room: focus_room, reserved_by: "Natalie",
  start_date: at.call(27, 11, 30),
  end_date: at.call(27, 12, 30)
)


puts "Seed completed successfully."
puts "Rooms: #{Room.count}"
puts "Reservations: #{Reservation.count}"
