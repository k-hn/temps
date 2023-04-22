import mist
import gleam/erlang/process
import routes
import glimt
import loggers
import gleam/int
import gleam/erlang/os
import gleam/result

pub fn main() {
  let port: Int = case os.get_env("PORT") {
    Ok(port) ->
      port
      |> int.parse
      |> result.unwrap(8080)
    Error(_) -> 8080
  }
  let host =
    os.get_env("HOST")
    |> result.unwrap("127.0.0.1")

  // Log server start message(json)
  let json_logger = loggers.get_json_logger(name: "json_logger")

  json_logger
  |> glimt.info(
    "Server running on http://" <> host <> ":" <> int.to_string(port),
  )

  // start server
  let assert Ok(_) =
    mist.run_service(
      // port
      port,
      // handler
      fn(req) { routes.router(req) },
      // body limit
      max_body_limit: 4_000_000,
    )
  process.sleep_forever()
}
