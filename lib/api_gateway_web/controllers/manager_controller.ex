defmodule ApiGatewayWeb.ManagerController do
  use ApiGatewayWeb, :controller

  def retrieveAllManagers(conn, _params) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :manager_request_queue))

    json(conn, response)

  end

  def retrieveManagerById(conn, %{"id" => id}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :manager_request_queue))

    json(conn, response)

  end

  def createManager(conn, %{"manager" => manager}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => manager})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :manager_request_queue))

    json(conn, response)

  end

end
