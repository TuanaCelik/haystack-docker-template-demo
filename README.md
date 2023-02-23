---
title: Haystack Docker Template Demo
emoji: 📉
colorFrom: pink
colorTo: yellow
sdk: docker
pinned: false
---

## Steps to run locally

- git clone the repo.
- docker pull elastic search: `docker pull docker.elastic.co/elasticsearch/elasticsearch:7.9.2`
- docker run elastic search: `docker run -d -p 9200:9200 -e "discovery.type=single-node" elasticsearch:7.9.2`
- find the elastic search host IP: `docker ps`, copy the container ID of elastic search, run `docker inspect <ID>`
- edit the `pipeline.yaml` with new IP address.  
- build the image: `docker build -t haystack_simple_demo -f Dockerfile .`
- run the image: `docker run -it --rm haystack_simple_demo`
- get the demo image IP in the same way as you did for elastic search IP

Now we can query this from terminal using following commands:

find ./test-data -name '*.txt' -exec  curl --request POST  --url http://<DEMO_IMAGE_IP>:8000/file-upload --header 'accept: application/json'  --header 'content-type: multipart/form-data'  --form files="@{}"   --form meta=null ;


curl --request POST --url http://<DEMO_IMAGE_IP>:8000/documents/get_by_filters --header 'accept: application/json' --header 'content-type: application/json' --data '{"filters": {}}'


curl --request POST --url http://<DEMO_IMAGE_IP>:8000/query --header 'accept: application/json' --header 'content-type: application/json' --data '{"query": "what is my name?"}'
