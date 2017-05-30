use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_chess, ExChess.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ex_chess, ExChess.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ex_chess_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "ExChessTest",
  ttl: {14, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "ldklkdjdldjkdlkjdlakjlakjalkja",
  serializer: ExChess.Accounts.GuardianSerializer
