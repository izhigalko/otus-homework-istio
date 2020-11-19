for APP_VERSION in 1.0.0 2.0.0 ; do
  echo ------------- ${APP_VERSION}
  tag=geracimov/otus-hw4-app:${APP_VERSION}
  docker build -t $tag --no-cache --build-arg APP_VERSION=${APP_VERSION} .
  #docker push $tag
done
