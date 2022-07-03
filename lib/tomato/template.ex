defmodule Tomato.Template do
  alias Tomato.Message

  @doc """
  Prepares the buttons template for the given buttons
  """
  @type message_button_type :: :postback | :url
  @type message_button :: {message_button_type, String.t(), String.t()}
  @type message_buttons :: [message_button]

  @spec buttons(map(), String.t(), message_buttons) :: map()
  def buttons(event, template_title, buttons) do
    buttons = Enum.map(buttons, &prepare_button/1)

    payload = %{
      "template_type" => "button",
      "text" => template_title,
      "buttons" => buttons
    }

    recipient = recipient(event)

    message = %{
      "attachment" => attachment("template", payload)
    }

    template(recipient, message)
  end

  @spec prepare_button(message_button()) :: map()
  def prepare_button({message_type, title, payload}) do
    %{
      "type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp recipient(event) do
    %{"id" => Message.get_sender(event)["id"]}
  end

  defp attachment(type, payload) do
    %{
      "type" => type,
      "payload" => payload
    }
  end

  defp template(recipient, message) do
    %{
      "message" => message,
      "recipient" => recipient
    }
  end

  def text(event, text) do
    %{
      "recipient" => recipient(event),
      "message" => %{"text" => text}
    }
  end
end
