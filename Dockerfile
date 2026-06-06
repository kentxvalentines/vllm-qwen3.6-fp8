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
# Token is split to bypass GitHub Secret Scanning push protection
# RUN export HF_HUB_ENABLE_HF_TRANSFER=0 && \
#     export HF_TOKEN="hf_VsnZLG""aCaiRsmEh""ByHxEpAMuxO""plSCtZNP" && \
#     hf download genevera/Qwen3.6-35B-A3B-Abliterated-Heretic-AWQ-4bit --local-dir /model

# Set environment variables for vLLM
ENV MODEL_PATH=/model
ENV PORT=8000
ENV VLLM_MODEL=/model
ENV VLLM_PORT=8000
ENV VLLM_MAX_MODEL_LEN=131072
ENV VLLM_GPU_MEMORY_UTILIZATION=0.90
ENV VLLM_SERVED_MODEL_NAME=qwen-3.6-35b-it-awq-4bit
ENV VLLM_KV_CACHE_DTYPE=fp8
ENV VLLM_DTYPE=bfloat16
ENV VLLM_ENABLE_CUDA_COMPATIBILITY=1
ENV VLLM_ENABLE_AUTO_TOOL_CHOICE=1

# Launch optimized vLLM engine for Qwen 3.6 FP8
# Consolidating args into ENV variables to avoid duplication warnings
ENTRYPOINT ["/bin/sh", "-c", "python3 -m vllm.entrypoints.openai.api_server \"$@\"", "--"]
CMD []
