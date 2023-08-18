defmodule ApiGatewayWeb.ContractController do
  use ApiGatewayWeb, :controller
  require Logger

  def getContract(conn, %{"id" => id}) do
    Logger.info("Contract ID: #{id}")
    {:ok, channel} = AMQP.Application.get_channel(:mychan)

    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true, auto_delete: true)
    {:ok, consumer_tag} = AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

    correlation_id = :erlang.unique_integer |> :erlang.integer_to_binary |> Base.encode64
    request = "{\"id\": #{id}}"
    AMQP.Basic.publish(channel, "", "file-request-queue", request, reply_to: queue_name, correlation_id: correlation_id)

    response = wait_for_message(channel, consumer_tag, correlation_id)

    put_resp_content_type(conn, "application/pdf")
    send_resp(conn, 200, response)
  end

end
