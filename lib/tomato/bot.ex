defmodule Tomato.Bot do
  @moduledoc false
  require Logger

  def verify_webhook(params) do
    facebook_chat_bot = Application.get_env(:tomato, :facebook_chat_bot)
    mode = params["hub.mode"]
    token = params["hub.verify_token"]

    mode == "subscribe" && token == facebook_chat_bot.webhook_verify_token
  end

  @spec send_message(map()) :: :ok | :error
  def send_message(msg_template) do
    endpoint = bot_endpoint()
    Logger.info(endpoint)
    headers = [{"content-type", "application/json"}]
    msg_template = Jason.encode!(msg_template)

    case HTTPoison.post(endpoint, msg_template, headers) do
      {:ok, _response} ->
        Logger.info("Message Sent to Bot")
        :ok

      {:error, reason} ->
        Logger.error("Error in sending message to bot, #{inspect(reason)}")
        :error
    end
  end

  @spec bot_endpoint() :: String.t()
  def bot_endpoint() do
    facebook_chat_bot = Application.get_env(:tomato, :facebook_chat_bot)
    page_token = facebook_chat_bot.page_access_token
    message_url = facebook_chat_bot.message_url
    base_url = facebook_chat_bot.base_url
    version = facebook_chat_bot.api_version
    token_path = "?access_token=#{page_token}"
    Path.join([base_url, version, message_url, token_path])
  end
end
