import gleam/http/response.{Response}
import gleam/http/request.{Request}
import gleam/bit_builder.{BitBuilder}

pub fn not_found(_request: Request(t)) -> Response(BitBuilder) {
  let body = bit_builder.from_string("404 Not Found")

  response.new(200)
  |> response.prepend_header("made-with", "Gleam")
  |> response.set_body(body)
}
