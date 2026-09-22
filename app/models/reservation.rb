class Reservation < ApplicationRecord
  belongs_to :room

  validates :reserved_by, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :end_date_after_start_date
  validate :room_capacity_available

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def room_capacity_available
    return if room.blank? || start_date.blank? || end_date.blank?
    return if end_date <= start_date

    overlapping_reservations = room.reservations.where("start_date < ? AND end_date > ?", end_date, start_date)

    if persisted?
      overlapping_reservations = overlapping_reservations.where.not(id: id)
    end

    events = []

    overlapping_reservations.each do |reservation|
      events << [reservation.start_date, 1]
      events << [reservation.end_date, -1]
    end

    events << [start_date, 1]
    events << [end_date, -1]

    events.sort_by! { |time, change| [time, change] }

    current_reservations = 0

    events.each do |_time, change|
      current_reservations += change

      if current_reservations > room.capacity
        errors.add(:base, "Room capacity would be exceeded")
        break
      end
    end
  end
end


