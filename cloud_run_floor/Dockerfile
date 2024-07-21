FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD exec gunicorn --bind 0.0.0.0:8080 --workers 1 --threads 8 app:app