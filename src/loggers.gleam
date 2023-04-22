import glimt.{Direct, append_instance, level, new}
import glimt/log_message.{TRACE, level_value}
import glimt/dispatcher/stdout.{dispatcher}
import glimt/serializer/json.{new_json_serializer}
import gleam/option.{None}

pub fn get_json_logger(name name: String) {
  new(name)
  |> level(TRACE)
  |> append_instance(Direct(
    None,
    level_value(TRACE),
    dispatcher(new_json_serializer()),
  ))
}
