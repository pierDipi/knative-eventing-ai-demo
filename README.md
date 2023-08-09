
Order of things:

1. [training](training)
  - Train the model
  - Export it
2. [inference_test](inference_test)
  - Sanity check the exported model
  - Plot the detections onto test images
3. [tensorflow_serving_test](tensorflow_serving_test)
  - Use the exported model in a TensorFlow Serving container
  - Send inference requests to the container
    - Prepare input
    - Process output
4. [kserve_test](kserve_test)
  - Use the exported model in KServe
  - Send inference requests to the KServe InferenceService
    - Prepare input
    - Process output
