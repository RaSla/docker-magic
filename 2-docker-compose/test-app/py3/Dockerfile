FROM python:3.6-alpine
#FROM python:3.6-onbuild
WORKDIR /app
COPY app/requirements.txt /app/
#COPY app /app
RUN set -ex \
# && pip install Flask \
# && pip install redis \
 && pip install -r requirements.txt \
 && python --version \
 && pip --version

CMD python app.py
