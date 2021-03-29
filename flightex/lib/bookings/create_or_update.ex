defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UserAgent

  def call(user_id, %{
        cidade_origem: cidade_origem,
        cidade_destino: cidade_destino
      })
      when is_bitstring(user_id) do
    booking_id = UUID.uuid4()

    with {:ok, _user} <- UserAgent.get(user_id),
         {:ok, data_completa} <- get_datetime_now(),
         {:ok, booking} <-
           Booking.build(booking_id, data_completa, cidade_origem, cidade_destino, user_id) do
      BookingAgent.save(booking)

      {:ok, booking.id}
    end
  end

  def call(_params), do: {:error, "Invalid parameters"}

  defp get_datetime_now do
    local_datetime = NaiveDateTime.local_now()

    NaiveDateTime.new(
      NaiveDateTime.to_date(local_datetime),
      NaiveDateTime.to_time(local_datetime)
    )
  end
end
