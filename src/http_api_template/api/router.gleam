import wisp.{type Request, type Response}
import http_api_template/api/web.{type Context}
import http_api_template/api/routes/orders

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["orders"] -> orders.all(req, ctx)
    _ -> wisp.not_found()
  }
}
