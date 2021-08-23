FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .

EXPOSE 8080

ARG service_version
ENV SERVICE_VERSION ${service_version:-v1}

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=8080"]
