import mist
import gleam/erlang/process
import routes

const port: Int = 8080

pub fn main() {
  // todo: Log server start message(json)

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
