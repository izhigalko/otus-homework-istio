import os

from aiohttp import web

routes = web.RouteTableDef()
memoized_times = None

version = os.getenv('APP_VERSION') or 'UNKNOWN'


@routes.get('/')
async def hello(request: web.Request):
    return web.Response(content_type='text/plain', text=f'Hello from app version {version}\n')


if __name__ == '__main__':
    app = web.Application()
    app.add_routes(routes)
    web.run_app(app, port=8080)
