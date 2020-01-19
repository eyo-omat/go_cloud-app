FROM golang:alpine AS build-env
#Here we give the image a variable name that we can refer to later, we call it build-env
WORKDIR /go/src
ADD . /go/src/welcome-app
RUN cd /go/src/welcome-app && go build -o main
#go build command creates a linux binary that can run without any go tooling.
FROM alpine
#Alpine is one of the lightest linux containers out there, only a few 4.15MB
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk*
WORKDIR /app
COPY --from=build-env /go/src/welcome-app/welcome-app /app
COPY --from=build-env /go/src/welcome-app/templates /app/templates
COPY --from=build-env /go/src/welcome-app/static /app/static
#Here we copy the binary from the first image (build-env) to the new alpine container
EXPOSE 8080
ENTRYPOINT [ “./welcome-app” ]
#We then run it on entry! 