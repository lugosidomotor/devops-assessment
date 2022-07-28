FROM alpine

LABEL maintainer="Csimpi Limpi <dik@duk.com>"

ARG username
ENV USERNAME $username

WORKDIR /app/
COPY ./hello.sh hello.sh

ENTRYPOINT [ "sh" ]
CMD ["hello.sh"]
