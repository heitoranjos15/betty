import Config

config :betty, ecto_repos: [Betty.Repo]

config :betty, Betty.Repo,
  database: "betty",
  username: "root",
  password: "root",
  hostname: "localhost"
