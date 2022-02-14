import platform

from aiohttp import web, client, ClientResponseError

routes = web.RouteTableDef()
memoized_times = None


@routes.get('/')
async def hello(request: web.Request):
    url = request.query.get('url', '')

    headers = '\n'.join(f'{k}: {v}' for k, v in request.headers.items())

    text = f'Request served by {platform.node()}\n\n'
    text += f'{request.version} {request.method} {request.url}\n\n'
    text += f'Request headers:\n\n{headers}\n\n'
    return web.Response(content_type='text/plain', text=text)

if __name__ == '__main__':
    app = web.Application()
    app.add_routes(routes)
    web.run_app(app, port=8080)
