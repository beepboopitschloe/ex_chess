use Mix.Config

config :ex_chess, ExChess.Web.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

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
