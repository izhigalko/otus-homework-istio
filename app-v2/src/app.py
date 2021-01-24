import platform

from aiohttp import web, client, ClientResponseError

routes = web.RouteTableDef()
memoized_times = None
app_version = "v2"


@routes.get('/')
async def hello(request: web.Request):
    url = request.query.get('url', '')

    headers = '\n'.join(f'{k}: {v}' for k, v in request.headers.items())

    text = f'Application version is: {app_version}\n\n'
    text += f'Request served by {platform.node()}\n\n'
    text += f'{request.version} {request.method} {request.url}\n\n'
    text += f'Request headers:\n\n{headers}\n\n'

    return web.Response(content_type='text/plain', text=text)


@routes.get('/error')
async def timeout(request: web.Request):
    global memoized_times
    times = int(request.query.get('times', '') or 0)

    if memoized_times is None:
        memoized_times = times + 1

    memoized_times -= 1
    status = 500

    if memoized_times <= 0:
        memoized_times = None
        status = 200

    return web.Response(content_type='text/plain', status=status)


if __name__ == '__main__':
    app = web.Application()
    app.add_routes(routes)
    web.run_app(app, port=8080)
