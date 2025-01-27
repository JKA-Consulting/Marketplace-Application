FROM python:slim

WORKDIR /app

COPY /app .

EXPOSE 8080

RUN pip install -r requirements.txt

CMD [ "python", "app.py" ]