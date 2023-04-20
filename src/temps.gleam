import mist
import gleam/http/response
import gleam/bit_builder
import gleam/erlang/process
import gleam/json.{object, string}
import birl/time

pub fn main() {
  let assert Ok(_) =
    mist.run_service(
      // port
      8080,
      // handler
      fn(_req) {
        let json_message =
          object([#("message", string("Hello, World"))])
          |> json.to_string
          |> bit_builder.from_string

        let date =
          time.utc_now()
          |> time.to_http()

        response.new(200)
        |> response.prepend_header(
          "content-type",
          "application/json; charset=utf-8",
        )
        |> response.prepend_header("Keep-Alive", "timeout=5")
        |> response.prepend_header("Date", date)
        |> response.set_body(json_message)
      },
      // body limit
      max_body_limit: 4_000_000,
    )
  process.sleep_forever()
}
