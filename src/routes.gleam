import gleam/http/response.{Response}
import gleam/http/request.{Request}
import gleam/bit_builder.{BitBuilder}
import gleam/http.{Get}
import handlers/not_found_handler
import handlers/datetime_handler

pub fn router(req: Request(t)) -> Response(BitBuilder) {
  case req.method, request.path_segments(req) {
    Get, ["datetime"] -> datetime_handler.index(req)
    _, _ -> not_found_handler.not_found(req)
  }
}
