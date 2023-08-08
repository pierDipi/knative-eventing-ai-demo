```shell
mkdir inference_test
cd inference_test

python3 -m venv .venv
source .venv/bin/activate

# install tensorflow
pip install --ignore-installed --upgrade tensorflow==2.5.0 matplotlib==3.6.3 pyqt5==5.15.9

# install TensorFlow object detection API from local
cd ../training/TensorFlow/models/research/
python -m pip install .
cd ../../../../inference_test

# verify dependencies
python -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
python -c "import matplotlib;"
python -c "import numpy;"
python -c "import PIL;"
python -c "import object_detection;"

# go back to `<root>`
cd ..
```

Run `plot.py` and you will see:
- GUI window with the image and the bounding boxes
- Image will be saved to `inference_test/plot/` with the bounding boxes
