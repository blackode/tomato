defmodule Tomato.MessageHandler do
  @moduledoc """
  Different types of messages handler
  """

  alias Tomato.{Bot, Message, Template}

  def handle_message(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_profile(event)
    {:ok, first_name} = Map.fetch(profile, "first_name")
    message = "Hello #{first_name}!"
    resp_template = Template.text(event, message)
    Bot.send_message(resp_template)
    request_color(event)
  end

  def handle_message(_message, event) do
    greetings = Message.greet()

    message = """
    #{greetings}

    Unknown Message Received :>
    """

    msg_template = Template.text(event, message)
    Bot.send_message(msg_template)
  end

  def handle_postback(%{"text" => "hi"}, event) do
    {:ok, profile} = Message.get_profile(event)
    {:ok, first_name} = Map.fetch(profile, "first_name")
    message = "Hello #{first_name}!"
    resp_template = Template.text(event, message)
    Bot.send_message(resp_template)
    request_color(event)
  end

  def handle_postback(%{"payload" => "color_" <> selected_color}, event) do
    event
    |> Template.text("Hola! You selected color #{selected_color}.")
    |> Bot.send_message()
  end

  defp request_color(event) do
    buttons = [
      {:postback, "Green", "color_green"},
      {:postback, "Red", "color_red"}
    ]

    template_title = "Which color do you like?"
    color_template = Template.buttons(event, template_title, buttons)

    Bot.send_message(color_template)
  end
end
