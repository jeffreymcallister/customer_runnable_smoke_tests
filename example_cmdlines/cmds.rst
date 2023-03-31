Example command lines
=====================

.. contents::

system_analyzer
---------------

checks system stack readiness to run applications

.. code-block:: bash

	system_analyzer


sample_decode
---------------

decode a file with VPL

.. code-block:: bash

	sample_decode h265 -i content/cars_320x240.h265


sample_multi_transcode
---------------

transcode a file with VPL

.. code-block:: bash

	sample_multi_transcode -i::h265 content/cars_320x240.h265 -o::h265 NUL


vpl-infer
---------------

simple decode->resize->infer object detection pipeline

.. code-block:: bash

	pushd vpl-infer
	rm -rf build; mkdir build; pushd build; cmake ..; make
	./vpl-infer -i ../../content/cars_320x240.h265 -m ../../content/public/mobilenet-ssd/FP32/mobilenet-ssd.xml -hw
	popd; popd


ffmpeg qsv decode
---------------

ffmpeg qsv decode without output

.. code-block:: bash

	ffmpeg -hwaccel qsv -c:v hevc_qsv -i content/cars_320x240.h265 -f null -


