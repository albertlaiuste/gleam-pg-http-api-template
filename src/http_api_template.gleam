import dot_env
import dot_env/env
import gleam/int
import gleam/pgo
import gleam/result
import gleam/option.{Some}
import mist
import wisp
import http_api_template/api/router
import http_api_template/api/web
import gleam/erlang/process

pub fn main() {
  dot_env.load()
  wisp.configure_logger()

  let port =
    int.parse(
      env.get("PORT")
      |> result.unwrap("3000"),
    )
    |> result.unwrap(3000)

  let secret_key_base = wisp.random_string(64)

  let _database_url =
    env.get("DATABASE_URL")
    |> result.unwrap("DATABASE_URL not set")

  let db =
    pgo.Config(
      ..pgo.default_config(),
      host: "localhost",
      port: 5432,
      user: "postgres",
      password: Some("password"),
      database: "template",
      pool_size: 1,
    )
    |> pgo.connect

  let context = web.Context(db: db)

  let handler = router.handle_request(_, context)

  let assert Ok(_) =
    handler
    |> wisp.mist_handler(secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}
