FROM alpine

LABEL maintainer="Csimpi Limpi <dik@duk.com>"

ARG username
ENV USERNAME $username

ENV USER=serviceuser
RUN adduser -D $USER
USER $USER

WORKDIR /app/
COPY ./hello.sh hello.sh

ENTRYPOINT [ "sh" ]
CMD ["hello.sh"]
