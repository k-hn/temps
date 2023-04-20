import mist
import gleam/http/response
import gleam/bit_builder
import gleam/erlang/process
import gleam/json.{int as json_int, object, string}
import birl/time
import gleam/io
import gleam/int

const port: Int = 8080

const host: String = "http://localhost"

pub fn main() {
  // print out server running message
  io.println("Server running on " <> host <> ":" <> int.to_string(port))

  // start server
  let assert Ok(_) =
    mist.run_service(
      // port
      8080,
      // handler
      fn(_req) {
        let now = time.utc_now()

        let date_in_parts =
          now
          |> time.get_date()

        let time_in_parts =
          now
          |> time.get_time()

        let json_message =
          object([
            #("datetime_http", string(time.to_http(now))),
            #("datetime", string(time.to_iso8601(now))),
            #("unix_timestamp", json_int(time.to_unix(now))),
            #("weekday", string(time.string_weekday(now))),
            #("month_string", string(time.string_month(now))),
            #("month_number", json_int(date_in_parts.1)),
            #("year", json_int(date_in_parts.0)),
            #("hours", json_int(time_in_parts.0)),
            #("minutes", json_int(time_in_parts.1)),
            #("seconds", json_int(time_in_parts.2)),
          ])
          |> json.to_string
          |> bit_builder.from_string

        response.new(200)
        |> response.prepend_header(
          "content-type",
          "application/json; charset=utf-8",
        )
        |> response.prepend_header("Keep-Alive", "timeout=5")
        |> response.prepend_header("Date", time.to_http(now))
        |> response.set_body(json_message)
      },
      // body limit
      max_body_limit: 4_000_000,
    )
  process.sleep_forever()
}
