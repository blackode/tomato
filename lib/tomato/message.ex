defmodule Tomato.Message do
  def get_sender(event) do
    messaging = get_messaging(event)
    messaging["sender"]
  end

  def get_recipient(event) do
    messaging = get_messaging(event)
    messaging["recipient"]
  end

  def get_messaging(event) do
    [entry | _any] = event["entry"]
    [messaging | _any] = entry["messaging"]
    messaging
  end

  def get_message(event) do
    messaging = get_messaging(event)
    messaging["message"]
  end

  def get_profile(event) do
    sender = get_sender(event)
    facebook_chat_bot = Application.get_env(:tomato, :facebook_chat_bot)
    page_token = facebook_chat_bot.page_access_token
    base_url = facebook_chat_bot.base_url
    version = facebook_chat_bot.api_version
    token_path = "?access_token=#{page_token}"
    profile_path = Path.join([base_url, version, sender["id"], token_path])

    case HTTPoison.get(profile_path) do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}

      {:error, error} ->
        {:enoprofile, error}
    end
  end

  def greet() do
    """
    Hello buddy :)
    Welcome to TOMATO
    """
  end
end
