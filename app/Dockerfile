FROM python:3

WORKDIR /opt/microservices
COPY requirements.txt /opt/microservices/
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py /opt/microservices/

EXPOSE 5000

ARG service_version
ENV SERVICE_VERSION ${service_version:-v1}

WORKDIR /opt/microservices
CMD ["python", "app.py"]
