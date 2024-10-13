defmodule GuitarAndBassExchangeWeb.PostController do
  use GuitarAndBassExchangeWeb, :controller

  def post(conn, _params) do
    render(conn, :show, layout: false)
  end
end
