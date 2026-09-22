class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
    @rooms = Room.all
  end

  def create
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      redirect_to room_path(@reservation.room)
    else
      @rooms = Room.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @rooms = Room.all
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update(reservation_params)
      redirect_to room_path(@reservation.room)
    else
      @rooms = Room.all
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :room_id, :reserved_by,
      :start_date, :end_date
    )
  end
end
