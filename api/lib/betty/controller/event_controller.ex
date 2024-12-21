defmodule Betty.Controller.Event do
  alias Betty.Boundary.EventSupervisor
  alias Betty.Lib.Dto.EventDto

  def start_event(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    content = Jason.decode!(conn.assigns[:raw_body])
    dto = %EventDto.CreateEvent {
      participants_uuid: content.participants_uuid,
      sport_uuid: content.sport_uuid,
    }
    EventSupervisor.start_event(content)
    Plug.Conn.send_resp(conn, 200, Jason.encode!(conn.body_params))
  end
end
