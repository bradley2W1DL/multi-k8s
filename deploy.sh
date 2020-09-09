#
# build production images
# tag each build with both latest and the current git commit sha
# "latest" for easy development env building
# "SHA" for production image management and debugging
#
docker build -t bradley2w1dl/multi-client:latest \
      -t bradley2w1dl/multi-client:$SHA \
      -f ./client/Dockerfile ./client

docker build -t bradley2w1dl/multi-server:latest \
      -t bradley2w1dl/multi-server:$SHA \
      -f ./server/Dockerfile ./server

docker build -t bradley2w1dl/multi-worker:latest \
      -t bradley2w1dl/multi-worker:$SHA \
      -f ./worker/Dockerfile ./worker

# push built images to docker hub
docker push bradley2w1dl/multi-client:latest
docker push bradley2w1dl/multi-server:latest
docker push bradley2w1dl/multi-worker:latest

docker push bradley2w1dl/multi-client:$SHA
docker push bradley2w1dl/multi-server:$SHA
docker push bradley2w1dl/multi-worker:$SHA

# apply all the config files from k8s/ dir
kubectl apply -f k8s

# imperatively set the image for the latest deployment
kubectl set image deloyments/server-deployment server=bradley2w1dl/multi-server:$SHA
kubectl set image deployments/client-deployment client=bradley2w1dl/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=bradley2w1dl/multi-worker:$SHA
