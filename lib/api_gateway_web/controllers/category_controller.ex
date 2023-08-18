defmodule ApiGatewayWeb.CategoryController do
use ApiGatewayWeb, :controller

def retrieveAllCategories(conn, _params) do

  jsonObject = Poison.encode!(%{"action" => "get", "data" => %{}})

  response = handleRPC(jsonObject, Application.get_env(:api_gateway, :category_request_queue))

  json(conn,response)

end

end
