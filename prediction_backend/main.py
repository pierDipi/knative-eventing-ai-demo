from flask import Flask, send_from_directory, request
from PIL import Image
import base64
import io
import numpy as np
import requests

app = Flask(__name__)


@app.get('/')
def send_report():
    return send_from_directory('.', 'index.html')


@app.post("/predict")
def hello_world():
    if "image_b64" not in request.json:
        return "Missing image_b64", 400

    imageBase64 = request.json["image_b64"]

    base64_decoded = base64.b64decode(imageBase64)

    image = Image.open(io.BytesIO(base64_decoded))
    image_np = np.array(image)

    # INFERENCE_RESULT=$(curl -H "Host: ${SERVICE_HOSTNAME}" "http://${INGRESS_HOST}:${INGRESS_PORT}/v1/models/demo01:predict" -d "{\"instances\": [ ${IMAGE_DATA} ]}")
    # curl -H Host: demo01.knative-ai-demo.example.com http://localhost:8080/v1/models/demo01:predict -d {"instances": [ [[[131, 126, 122], [136, 131, 127], ... ]]]}

    # TODO: make this configurable
    URL = 'http://localhost:8080/v1/models/demo01:predict'
    headers = {'Host': 'demo01.knative-ai-demo.example.com'}
    payload = {'instances': [image_np.tolist()]}

    call = requests.post(URL, json=payload, headers=headers)
    inference = call.json()

    # we only call with one image, so we only have one prediction
    predictions = inference['predictions'][0]

    if int(predictions["num_detections"]) == 0:
        return {
            "score": 0,
            "box": [0, 0, 0, 0],
        }, 200

    # highest score is the first one
    highest_score = predictions["detection_scores"][0]
    highest_score_box = predictions["detection_boxes"][0]

    return {
        "score": highest_score,
        "box": highest_score_box,
    }, 200
