import os

from fastapi import FastAPI

app = FastAPI()


@app.get("/version")
async def root():
    return {"version": os.getenv("APP_VERSION")}


@app.get("/health")
async def health():
    return {"status": "OK"}
