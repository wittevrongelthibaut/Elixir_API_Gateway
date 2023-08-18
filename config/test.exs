import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_gateway, ApiGatewayWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RdRlfHbgMXF5CaLq17ucUDQDJgUAgpdF2vvFu0mxc6vfW5Wawm9pPw6pQwl6bbyn",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
