defmodule ApiGatewayWeb.TeacherController do
  use ApiGatewayWeb, :controller

  def retrieveAllTeachers(conn, _params) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :teacher_request_queue))

    json(conn, response)

  end

  def retrieveTeacherById(conn, %{"id" => id}) do

    jsonObject = Poison.encode!(%{"action" => "get", "data" => %{"id" => String.to_integer(id)}})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :teacher_request_queue))

    json(conn, response)

  end

  def createTeacher(conn, %{"teacher" => teacher}) do

    jsonObject = Poison.encode!(%{"action" => "add", "data" => teacher})

    response = handleRPC(jsonObject, Application.get_env(:api_gateway, :teacher_request_queue))

    json(conn, response)

  end

end
