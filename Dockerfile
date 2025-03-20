FROM gcr.io/kaniko-project/executor:debug AS kaniko
FROM alpine/git

COPY --from=kaniko /kaniko/executor /kaniko/executor

ENTRYPOINT ["/kaniko/executor"]
