import gleam/json

pub fn to_json(orders) {
  let o =
    json.array(orders, fn(order) {
      let #(id, status) = order
      json.object([#("id", json.int(id)), #("status", json.string(status))])
    })

  json.to_string_builder(o)
}
