Customer Runnable Linux Media + AI Smoke Tests
==============================================

.. contents::


Background
----------

Reason for adding customer runnable tests: out-of-box experience remains poor, especially beyond basic media.

Approach used for this project: focus on the example command lines we would tell customers to run as they are getting started.
This gap has been identified in multiple DX studies, so this area is clear for us to own w/o extensive negotiations.
These command lines we document must include interoperability with more than the basic media stack.

Scope for test cases
---------------------
A *short* list (<50 total) of command lines used in our documentation. 
 - NOT VPL-only acceptance tests
 - NOT lower level VPL-only component level tests

Interop scenarios are our new default.  Media only is an increasingly rare corner case.
While it is theoretically possible to set up a system with everything, everything enabled is a rare corner case.

Direction for Linux releases is composable packages.  Some examples of configurations to document:
 #. apt install intel-gpu-media (VPL only)
 #. apt install intel-gpu-media, then build ffmpeg with --enable-vpl
 #. apt install intel-gpu-media, then build gstreamer with VPL plugin
 #. apt install intel-gpu-media + intel-gpu-compute (openCL)
 #. apt install intel-gpu-media + intel-gpu-compute + openvino
 #. apt install intel-gpu-media + Vulkan
 #. apt install intel-gpu-media + Mesa (openGL)

Project scope is smoke tested example command lines for every composable media stack scenario we claim in our marketing.
We will only provide a few command lines (<5) for each package install scenario, just enough to fulfill the goal of basic
smoke tests that the configuration works.

Subset to prioritize in Q2
--------------------------
Simple is hard.  Just getting buy-in on a subset of the <50 total example command lines will be challenging.
First group to implement is VPL only, VPL+ffmpeg, VPL+OpenCL, and VPL+OpenVINO 

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

