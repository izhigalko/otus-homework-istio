import platform

from aiohttp import web, client, ClientResponseError


async def proxy(request):
    url = request.query.get('url')

    headers = '\n'.join(f'{k}: {v}' for k, v in request.headers.items())

    text = f'Request served by {platform.node()}\n\n'
    text += f'{request.version} {request.method} {request.url}\n\n'
    text += f'Request headers:\n\n{headers}\n\n'

    if url:
        s: client.ClientSession
        r: client.ClientResponse

        async with client.ClientSession(raise_for_status=True) as s:
            data = None
            if request.can_read_body:
                data = await request.text()

            ext_req_headers = {}
            token = request.headers.get('X-AUTH-TOKEN')
            if token:
                ext_req_headers['X-AUTH-TOKEN'] = token

            try:
                async with s.request(request.method, url, headers=ext_req_headers, data=data) as r:
                    body = await r.text()
                    headers = '\n'.join(f'{k}: {v}' for k, v in r.headers.items())
                    text += f'Remote status: {r.status}\n\nRemote headers:\n\n{headers}\n\nRemote body:\n\n{body}'
            except ClientResponseError as e:
                headers = '\n'.join(f'{k}: {v}' for k, v in e.headers.items())
                text += f'Remote error with status: {e.status}\n\nRemote headers: {headers}'
            except Exception as e:
                text += f'Remote error: {str(e)}'
    else:
        text += 'There is no URL param for request'

    return web.Response(content_type='text/plain', text=text)


async def theroot(request):
    return web.Response(content_type='text/plain', text=f'Request served by {platform.node()}')


async def health(request):
    return web.Response(content_type='text/plain', text="I'm ok")


if __name__ == '__main__':
    app = web.Application()
    app.add_routes([
        web.get('/proxy', proxy),
        web.get('/', theroot),
        web.get('/health/', health),

    ])
    web.run_app(app, port=8080)
