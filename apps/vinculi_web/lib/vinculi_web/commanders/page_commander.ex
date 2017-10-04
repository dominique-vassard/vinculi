defmodule VinculiWeb.PageCommander do
  use Drab.Commander
  # Place your event handlers here
  #
  # def button_clicked(socket, sender) do
  #   set_prop socket, "#output_div", innerHTML: "Clicked the button!"
  # end
  #
  # Place you callbacks here
  #
  onload :page_loaded
  #
  def page_loaded(socket) do
    poke socket, page_name: "Hacked by drab!"
    set_prop socket, "div.jumbotron p.lead", innerHTML: "This page has been drabbed"
  end
end
