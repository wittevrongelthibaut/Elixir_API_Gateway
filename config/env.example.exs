import Config

config :api_gateway,
  rabbitmq_connection: "{RABBITMQ_CONNECTION_STRING}",
  student_request_queue: "{STUDENT_REQUEST_QUEUE}",
  company_request_queue: "{COMPANY_REQUEST_QUEUE}",
  internship_request_queue: "{INTERNSHIP_REQUEST_QUEUE}",
  application_request_queue: "{APPLICATION_REQUEST_QUEUE}",
  teacher_request_queue: "{TEACHER_REQUEST_QUEUE}",
  manager_request_queue: "{MANAGER_REQUEST_QUEUE}",
  chatmessage_request_queue: "{CHATMESSAGE_REQUEST_QUEUE}",
  category_request_queue: "{CATEGORY_REQUEST_QUEUE}"
