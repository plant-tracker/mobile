#!/bin/sh

docker compose exec --workdir /application/src/android dev ./gradlew signingReport
