FROM amazoncorretto:8-alpine AS build

WORKDIR /src
COPY src .
RUN set -ex \
  && javac -d . test_java.java \
  && ls -al bin/

CMD ["sh", "-c", "time java -classpath . bin.test_java"]
