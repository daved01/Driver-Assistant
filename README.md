# Driver Assist

A vision-based driver assistant for iOS.

# Exporting The YOLOv5 Model into CoreML

Although there is an export function provided by Glenn Jocher and the YOLOv5 team, the trace function used in it does not export many of the post-processing steps such as adjusting the coordinates to be relative to the image rather than the grid cell. Fortunately, Leon de Andrade and Dennis Post have provided a repo to export the YOLOv5 model with all of these post-processing steps here (https://github.com/dbsystel/yolov5-coreml-tools).

We have used their repo to export out model with some minor modifications. An older version of YOLOv5 (v4.0) has been provided with this repo for your convenience. The following instructions are based on the (https://github.com/dbsystel/yolov5-coreml-tools) repo.

To export the model into CoreML, install poetry (https://python-poetry.org/docs/). Poetry is used to install the required libraries to export the model. Export it by navigating to the export/yolov5-coreml-tools folder and then using the following command

```console 
$ poetry install
```

CoreML tools only works for certain versions of PyTorch, so the following commands may be preferred

```
$ pyenv install 3.8.6
$ pyenv global 3.8.6
$ poetry install
```

In the src/coreml_export/main.py folder, you may want to change some of the variables such as

* `classLabels` -> A list of the names of the classes. In COCO, there are 80 classes.
* `anchor` -> This depends on the YOLOv5 model that you are using (x, m, l, xl). This can be found in the "yolo<model>.yml" file
* `reverseModel` -> Some models reverse the order of the anchors and strides, so this is used to quickly switch reverse their order.

Then you may paste your .pt network model in the yolov5-coreml-tools folder. To finally run the export program, you may use the command

```
$ poetry run coreml-test --model-input-path <path to .pt file>
```

And you can use the -h flag to get a list of the optional arguments for your export. The model will save your exported model in the output/models folder.