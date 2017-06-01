use Mix.Config

config :ex_chess, ExChess.Web.Endpoint,
  on_init: {ExChess.Web.Endpoint, :load_from_system_env, []},
  url: [host: "intense-lake-14088.herokuapp.com", port: 443],
  check_origin: ["https://diplomat-robert-25142.netlify.com"],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :ex_chess, ExChess.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "ExChess",
  ttl: {14, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: System.get_env("JWT_KEY"),
  serializer: ExChess.Accounts.GuardianSerializer

config :logger, level: :info
