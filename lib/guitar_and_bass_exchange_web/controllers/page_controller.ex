defmodule GuitarAndBassExchangeWeb.PageController do
  use GuitarAndBassExchangeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def terms(conn, _params) do
    render(conn, :terms, layout: false)
  end

  def privacy(conn, _params) do
    render(conn, :privacy, layout: false)
  end
end
