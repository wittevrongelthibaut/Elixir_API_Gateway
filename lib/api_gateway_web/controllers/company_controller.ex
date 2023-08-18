defmodule ApiGatewayWeb.CompanyController do
  use ApiGatewayWeb, :controller
  require Logger

  def retrieveAllCompanies(conn, _params) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :company_request_queue))

    json(conn,response)

  end

  def retrieveCompanyById(conn, %{"id" => id}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :company_request_queue))

    json(conn, response)

  end

  def createCompany(conn, %{"company" => company}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => company})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :company_request_queue))

    json(conn, response)

  end

  def retrieveInternshipsByCompanyId(conn, %{"id" => id}) do

    jsonObject = Poison.encode!(%{"action" => "getinternships", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :company_request_queue))

    json(conn, response)

  end

end
