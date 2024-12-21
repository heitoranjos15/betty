defmodule Betty.Api do
  use Plug.Router
  alias Betty.Controller

  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/*"],
    body_reader: {CacheBodyReader, :read_body, []},
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "world")
  end

  post "/" do
    Controller.Event.start_event(conn, opts)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end

defmodule CacheBodyReader do
  def read_body(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end
end
