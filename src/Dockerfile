FROM python:3.9-slim-buster

EXPOSE 8080
WORKDIR /src

COPY ./requirements.txt ./
RUN echo ' ---> Install additional dependencies' && pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "server.py"]