defmodule ApiGatewayWeb.Router do
  use ApiGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiGatewayWeb do
    pipe_through :api

    get "/contracts/:id", ContractController, :getContract

    get "/students", StudentController, :retrieveAllStudents
    get "/students/:id", StudentController, :retrieveStudentById
    post "/students", StudentController, :createStudent
    get "/students/:id/internship", StudentController, :retrieveInternshipsByStudentId

    get "/companies", CompanyController, :retrieveAllCompanies
    get "/companies/:id", CompanyController, :retrieveCompanyById
    get "/companies/:id/internships", CompanyController, :retrieveInternshipsByCompanyId
    post "/companies", CompanyController, :createCompany

    get "/internships", InternshipController, :retrieveAllInternships
    get "/internships/:id", InternshipController, :retrieveInternshipById
    post "/internships", InternshipController, :createInternship
    patch "/internships/:internshipId/assign/:studentId", InternshipController, :assignStudentToInternship
    patch "/internships/:internshipId/approve", InternshipController, :approveInternship
    patch "/internships/:internshipId/deny", InternshipController, :denyInternship

    get "/applications/:internshipId", ApplicationController, :retrieveAllInternshipApplications
    post "/applications", ApplicationController, :createApplication
    post "/applications/:internshipId/approve/:internId", ApplicationController, :approveApplication
    post "/applications/:internshipId/deny/:internId", ApplicationController, :denyApplication

    get "/teachers", TeacherController, :retrieveAllTeachers
    get "/teachers/:id", TeacherController, :retrieveTeacherById
    post "/teachers", TeacherController, :createTeacher

    get "/managers", ManagerController, :retrieveAllManagers
    get "/managers/:id", ManagerController, :retrieveManagerById
    post "/managers", ManagerController, :createManager

    get "/chatmessages/:companyId/:studentId", ChatmessageController, :retrieveAllChatmessages
    post "/chatmessages", ChatmessageController, :createChatmessage

    get "/categories", CategoryController, :retrieveAllCategories
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ApiGatewayWeb.Telemetry
    end
  end
end
