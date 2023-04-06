Customer Runnable Linux Media+AI pipeline smoke tests
=====================================================

.. contents::


Background
----------

Intel out-of-box experience remains poor for users attempting to access our GPU capabilities.
The experience becomes worse as the stack becomes taller.

This project has 2 goals:
 **external**: customers need a simple way to check that their environment is suitable to run media+AI pipelines
 **internal**: drive consensus on supported/validated configurations so that component, validation, and release teams have at least minimal guidance.  Without a clear definition each team must work harder to define their own validated configurations and deal with reported issues. 

Scope for test cases
---------------------
A *short* list (<50 total) of command lines expected to work in well defined install configurations.
Each test will be expressed as a statement that is clearly true or false.
Multiple tests can be available for each stack configuration.
In the initial implementation all tests will run by default, but in the future a configuration file will be added to turn off tests not intended to work.

Metapackage definitions used in the table below:
 - intel-gpu-media = gmmlib, media driver, libdrm, libva, libvpl
 - intel-gpu-compute = gmmlib, L0, opencl, …
 - intel-ffmpeg = ffmpeg build enabling all Intel capabilities (vaapi and qsv)
 - intel-gstreamer = gstreamer build including vaapi and VPL plugins

Long term goal is to sync definitions here with  https://github.com/intel-sandbox/jpk.package-test/blob/main/docs/meta-packages.md


+-----------------------------------------------------------+----------------------------------------------------+
| Stack components                                          | Test case names                                    |
+===========================================================+====================================================+
| | apt install intel-gpu-media                             | | Libva-only pipeline works                        |
| |                                                         | | VPL-only pipeline works                          |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-compute                           | | Opencl-only pipeline works                       |
| |                                                         | | Intel graphics compiler works                    |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media intel-ffmpeg                | | FFmpeg vaapi hwaccel pipeline works              |
|                                                           | | FFmpeg qsv hwaccel pipeline works                |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media  intel-gstreamer            | | Gstreamer vaapi plugin works                     |
| |                                                         | | Gstreamer msdk/VPL plugin works                  |
+-----------------------------------------------------------+----------------------------------------------------+
| apt install intel-gpu-media  libva-dev                    | VPL + libva pipeline works                         |
+-----------------------------------------------------------+----------------------------------------------------+
| apt install intel-gpu-media  intel-gpu-compute            | VPL + OpenCL pipeline works, VPL+L0 pipeline works |
+-----------------------------------------------------------+----------------------------------------------------+
| apt install intel-gpu-media  intel-gpu-compute  openvino  | VPL + OpenVINO pipeline works                      |
+-----------------------------------------------------------+----------------------------------------------------+
| apt install intel-gpu-media + Vulkan dev install          | VPL + Vulkan pipeline works                        |
+-----------------------------------------------------------+----------------------------------------------------+
| apt install intel-gpu-media + OpenGL dev install          | VPL+OpenGL pipeline works                          |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media intel-ffmpeg + ITEX         | | FFmpeg vaapi hwaccel + ITEX pipeline works       |
| |                                                         | | FFmpeg qsv hwaccel + ITEX pipeline works         |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media intel-gstreamer + ITEX      | | Gstreamer vaapi plugin works w/ITEX              |
| |                                                         | | Gstreamer msdk/VPL plugin works w/ITEX           |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media intel-ffmpeg + IPEX         | | FFmpeg vaapi hwaccel + IPEX pipeline works       |
| |                                                         | | FFmpeg qsv hwaccel + IPEX pipeline works         |
+-----------------------------------------------------------+----------------------------------------------------+
| | apt install intel-gpu-media intel-gstreamer + IPEX      | | Gstreamer vaapi plugin works w/ITEX              |
| |                                                         | | Gstreamer msdk/VPL plugin works w/ITEX           |
+-----------------------------------------------------------+----------------------------------------------------+



Publishing mechanism
--------------------
Example command lines and tests to be published via github repository.  
Link to public github repository to be provided on VPL website.
This repo is to develop the concept before we set up path to publication.


Supported Hardware and OSes
---------------------------

Hardware and OSes documented at https://dgpu-docs.intel.com/
This repository will focus on latest Ubuntu and Redhat in Q2.


Setup Steps
------------

Setup steps are internal only to bootstrap the project.
By external release we should have reasonable metapackages available.


How to Run Tests
----------------

.. code-block:: bash

  $ cd cmdlines
  $ python runcmd.py -c test_cmds.yaml
(next update: run.sh)


How simplicity and good UX will be preserved as expanded
--------------------------------------------------------

 - yaml files any python runner are self documenting
 - focus on published example command lines only forces # of test cases to stay small
 - utilities can list which test sets are available and which are runnable in the current environment
 - concurrent work to simplify stack install with composable metapackages replaces the need for long + error prone descriptions of environment setup

Contributing
------------

Feedback and contributions are welcome. Please, submit
 - **issues** https://github.com/jeffreymcallister/customer_runnable_smoke_tests/issues
 - **pull requests** https://github.com/jeffreymcallister/customer_runnable_smoke_tests/pulls

