FROM python:3-alpine
WORKDIR /app
ADD . /app
RUN pip install Flask
EXPOSE 8080
CMD ["python", "app.py"]

