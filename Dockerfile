# NOTE: This is a sample dockerfile for creating docker images for deploying
#       a haystack pipeline. Follow the comments and make suitable changes for your use-case.
#
# Use-case showcased here:
#       Dockerfile for a <blah> pipeline
#
# 
# We also show how to cache HuggingFace models; both public and private. More details in the comments.
# CAUTION: Do not use `huggingface-cli login` inside the docker as it store the access token locally
#          Here we prefer passing access token as an `ARG` because,
#          we only need to use access token to cache required model.
#          Also, Do not create an ENV variable containing access token,
#          as ENV variable remains active inside docker for its entire lifecycle.
#          To know futher: https://huggingface.co/docs/hub/security-tokens#best-practices

# Choose appropriate Haystack base image (i.e. v1.13.2)
ARG HAYSTACK_BASE_IMAGE=deepset/haystack:cpu-v1.13.2
FROM $HAYSTACK_BASE_IMAGE

#ARG hf_model_names="['deepset/minilm-uncased-squad2']"
# `hf_model_names` should be a list of string containing model names from HuggingFace hub
# i.e., "['hf/model1']"        or        "['hf/model1', 'hf/model2', 'hf/model3']"

#ARG hf_token=''

# To cache HuggingFace public models
#RUN python3 -c "from haystack.utils.docker import cache_models;cache_models($hf_model_names)"

# To cache HuggingFace private models
#RUN python3 -c "from haystack.utils.docker import cache_models;cache_models($hf_model_names, $hf_token)"

# To copy pipeline yml into the docker
ARG local_pipeline_path=<blah>.yml
ARG container_pipeline_path=/opt/haystack_pipelines/reader_retriever.yml
COPY $local_pipeline_path $container_pipeline_path

# Exporting Pipeline path as an env variable
# Haystack reads this env variable to load the appropriate pipeline
ENV PIPELINE_YAML_PATH=$container_pipeline_path

RUN chmod 700 /opt/file-upload
# cmd for starting Haystack API server
CMD ["gunicorn", "rest_api.application:app",  "-b", "0.0.0.0", "-k", "uvicorn.workers.UvicornWorker", "--port", "7860", "--workers", "1", "--timeout", "180"]


