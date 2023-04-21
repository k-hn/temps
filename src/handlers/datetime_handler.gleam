import gleam/http/request.{Request}
import gleam/http/response.{Response}
import gleam/bit_builder.{BitBuilder}
import birl/time
import gleam/json.{int as json_int, object, string}

pub fn index(_request: Request(t)) -> Response(BitBuilder) {
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
  |> response.prepend_header("content-type", "application/json; charset=utf-8")
  |> response.prepend_header("Keep-Alive", "timeout=5")
  |> response.prepend_header("Date", time.to_http(now))
  |> response.set_body(json_message)
}
