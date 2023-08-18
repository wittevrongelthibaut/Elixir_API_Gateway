defmodule ApiGatewayWeb.StudentController do
  use ApiGatewayWeb, :controller
  require Logger

  def retrieveAllStudents(conn, _params) do
    jsonObject =Poison.encode!(%{ "action" => "get", "data" => %{}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :student_request_queue))

    json(conn, response)
  end

  def retrieveStudentById(conn, %{"id" => id}) do
    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :student_request_queue))

    json(conn, response)
  end

  def createStudent(conn, %{"student" => student}) do
    jsonObject = Poison.encode!(%{"action" => "add", "data" => student})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :student_request_queue))

    json(conn, response)
  end

  def retrieveInternshipsByStudentId(conn, %{"id" => id}) do
    jsonObject = Poison.encode!(%{"action" => "studentinternships", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :student_request_queue))

    json(conn, response)
  end
end
