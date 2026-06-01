# Use the official vLLM OpenAI-compatible base image
FROM vllm/vllm-openai:latest

# Expose the API port
EXPOSE 8000

# =========================================================================
# STRATEGY 1: LOCAL BUILD (Default)
# Copy the already-downloaded local model files and custom configuration files.
# =========================================================================
COPY . /model/

# =========================================================================
# STRATEGY 2: CLOUD BUILD (Commented Out)
# If building on GitHub Actions or a remote builder, comment out the COPY statements 
# above, uncomment the lines below, and provide your HF token if required.
# =========================================================================
# RUN pip install huggingface_hub
# RUN python3 -c "from huggingface_hub import snapshot_download; \
#     snapshot_download(repo_id='coolthor/Huihui-Qwen3.6-35B-A3B-abliterated-FP8-DYNAMIC', local_dir='/model')"

# Set environment variables for vLLM
ENV MODEL_PATH=/model
ENV PORT=8000
ENV MAX_MODEL_LEN=131072
ENV GPU_MEMORY_UTILIZATION=0.90
ENV SERVED_MODEL_NAME=qwen-3.6-35b-it-fp8
ENV KV_CACHE_DTYPE=fp8
ENV DTYPE=bfloat16
ENV VLLM_ENABLE_CUDA_COMPATIBILITY=1

# Launch optimized vLLM engine for Qwen 3.6 FP8
ENTRYPOINT ["/bin/sh", "-c", "python3 -m vllm.entrypoints.openai.api_server --model /model --port $PORT --served-model-name $SERVED_MODEL_NAME --kv-cache-dtype $KV_CACHE_DTYPE --dtype $DTYPE --max-model-len $MAX_MODEL_LEN --gpu-memory-utilization $GPU_MEMORY_UTILIZATION --enable-auto-tool-choice \"$@\"", "--"]
CMD []
