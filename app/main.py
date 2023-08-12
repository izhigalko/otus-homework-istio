from fastapi import FastAPI, Request

app = FastAPI()


@app.get('/')
async def root(request: Request):
    return {
        'status': 'OK',
        'client_host': request.client.host
    }