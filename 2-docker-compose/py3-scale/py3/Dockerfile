FROM python:3.7-alpine
WORKDIR /app
ENV PYTHONUNBUFFERED=1\
    # чтобы логи нормально вылезали из контейнера
    PYTHONDONTWRITEBYTECODE=1
    #кэш питон-кода
COPY app/requirements.txt /app/
RUN set -ex \
  && pip install --upgrade pip \
  && pip install -r requirements.txt \
  && python --version \
  && pip --version

## Copy App in docker-image - for the Production
#COPY app /app
## or mount App-volume in docker-compose.yml - for the Development

CMD python app.py
