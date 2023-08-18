defmodule ApiGatewayWeb.InternshipController do
  use ApiGatewayWeb, :controller
  require Logger

  def retrieveAllInternships(conn, params) do

    jsonObject =
    if params["recommendationsFor"] != nil do
      Poison.encode!(%{ "action" => "recommendations", "data" => %{ "id" => String.to_integer(params["recommendationsFor"])}})
    else
      Poison.encode!(%{ "action" => "get", "data" => %{}})
    end

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

  def retrieveInternshipById(conn, %{"id" => id}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

  def createInternship(conn, %{"internship" => internship}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => internship})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

  def assignStudentToInternship(conn, %{"internshipId" => internshipId, "studentId" => studentId}) do

    jsonObject = Poison.encode!(%{"action" => "assignstudent", "data" => %{"internshipId" => String.to_integer(internshipId), "studentId" => String.to_integer(studentId)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

  def approveInternship(conn, %{"internshipId" => internshipId}) do

    jsonObject = Poison.encode!(%{"action" => "approve", "data" => %{"internshipId" => String.to_integer(internshipId)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

  def denyInternship(conn, %{"internshipId" => internshipId}) do

    jsonObject = Poison.encode!(%{"action" => "deny", "data" => %{"internshipId" => String.to_integer(internshipId)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :internship_request_queue))

    json(conn, response)

  end

end
