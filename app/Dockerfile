FROM python:3.9

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache -r requirements.txt

COPY . .

ARG app_version
ENV APP_VERSION ${app_version}

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]
