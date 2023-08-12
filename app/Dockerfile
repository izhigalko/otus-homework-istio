FROM python:3.11.3-alpine
WORKDIR /app
COPY main.py requirements.txt ./
RUN pip install -r ./requirements.txt
EXPOSE 8000
CMD [ "uvicorn" , "main:app", "--host", "0.0.0.0", "--port", "8000"]