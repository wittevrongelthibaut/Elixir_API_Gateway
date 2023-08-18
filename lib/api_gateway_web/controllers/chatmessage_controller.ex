defmodule ApiGatewayWeb.ChatmessageController do
  use ApiGatewayWeb, :controller

  def retrieveAllChatmessages(conn, %{"companyId" => companyId, "studentId" => studentId}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"companyId" => String.to_integer(companyId), "studentId" => String.to_integer(studentId)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :chatmessage_request_queue))

    json(conn, response)

  end

  def createChatmessage(conn, %{"chatmessage" => chatmessage}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => chatmessage})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :chatmessage_request_queue))

    json(conn, response)

  end
end
