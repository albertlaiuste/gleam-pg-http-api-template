import wisp.{type Request, type Response}
import gleam/http.{Get}
import gleam/dynamic
import gleam/pgo
import gleam/result
import http_api_template/api/web.{type Context}
import http_api_template/api/json/orders.{to_json}

pub fn all(req: Request, ctx: Context) -> Response {
  let list_orders = fn() {
    let sql = "SELECT id, status FROM public.orders"
    let order_type = dynamic.tuple2(dynamic.int, dynamic.string)
    let orders =
      pgo.execute(sql, ctx.db, [], order_type)
      |> result.try(fn(query_result) { Ok(query_result.rows) })

    case orders {
      Ok(order) -> wisp.json_response(to_json(order), 200)
      Error(_) -> wisp.internal_server_error()
    }
  }

  case req.method {
    Get -> list_orders()
    _ -> wisp.method_not_allowed(allowed: [Get])
  }
}
