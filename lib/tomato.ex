defmodule Tomato do
  @moduledoc """
   Main Entry for Events where redirect based on the event category
  """

  alias Tomato.{Message, MessageHandler, Template}

  def handle_event(event) do
    case Message.get_messaging(event) do
      %{"message" => message} ->
        MessageHandler.handle_message(message, event)

      %{"postback" => postback} ->
        MessageHandler.handle_postback(postback, event)

      _ ->
        error_template =
          Template.text(event, "Something went wrong. Our Engineers are working on it.")

        Tomato.Bot.send_message(error_template)
    end
  end
end
