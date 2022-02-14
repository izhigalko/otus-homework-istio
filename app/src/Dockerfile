FROM python:3.7-slim

EXPOSE 8080
RUN pip install --no-cache-dir aiohttp

COPY app.py /app.py

CMD ["python", "/app.py"]
