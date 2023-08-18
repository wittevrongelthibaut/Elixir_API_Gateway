defmodule ApiGatewayWeb.ApplicationController do
  use ApiGatewayWeb, :controller
  require Logger

  def retrieveAllInternshipApplications(conn, %{"internshipId" => internshipId}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(internshipId)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :application_request_queue))

    json(conn, response)

  end

  def createApplication(conn, %{"application" => application}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => application})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :application_request_queue))

    json(conn, response)

  end

  def approveApplication(conn, %{"internshipId" => internshipId, "internId" => internId}) do

    jsonObject = Poison.encode!(%{"action" => "update", "data" => %{"internshipId" => String.to_integer(internshipId), "internId" => String.to_integer(internId), "accepted" => true}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :application_request_queue))

    json(conn, response)

  end

  def denyApplication(conn, %{"internshipId" => internshipId, "internId" => internId}) do

    jsonObject = Poison.encode!(%{"action" => "update", "data" => %{"internshipId" => String.to_integer(internshipId), "internId" => String.to_integer(internId), "accepted" => false}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :application_request_queue))

    json(conn, response)

  end
end
