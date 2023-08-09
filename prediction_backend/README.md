```shell
mkdir prediction_backend

cd prediction_backend

python3 -m venv .venv
source .venv/bin/activate

pip install flask==2.3.2 pillow==10.0.0 numpy==1.25.2 requests==2.31.0

# verify dependencies
python -c "import numpy;"
python -c "import PIL;"
python -c "import flask;"
python -c "import requests;"

flask --app main run
```
