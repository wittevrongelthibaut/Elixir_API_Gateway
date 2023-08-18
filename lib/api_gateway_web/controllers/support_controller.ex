defmodule ApiGatewayWeb.SupportController do
  require Logger

  @spec wait_for_message(any, any, any) :: any
  def wait_for_message(channel, consumer_tag, correlation_id) do
    receive do
      {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
        AMQP.Basic.cancel(channel, consumer_tag)
        payload
    end
  end

  def handleRPC(jsonObject, pubQueue) do
    {:ok, channel} = AMQP.Application.get_channel(:mychan)

    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true, auto_delete: true)
    {:ok, consumer_tag} = AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

    correlation_id = :erlang.unique_integer |> :erlang.integer_to_binary |> Base.encode64

    AMQP.Basic.publish(channel, "", pubQueue, jsonObject, reply_to: queue_name, correlation_id: correlation_id)

    response = wait_for_message(channel, consumer_tag, correlation_id)
    Poison.decode!(response)
  end

end
