Customer Runnable Linux Media + AI Smoke Tests
==============================================

.. contents::


Background
----------

Intel brings vendor choice to the GPU market.  In addition to competitive hardware, the market has said it wants an open, 
composable stack allowing components to be plugged together like Lego blocks.  If Intel can deliver this our stack will 
become a competitive advantage.

Unfortunately there are many gaps in this vision today.  Release dashboards are green at a component level but customer-level integration
remains problematic.  This is still happening despite large investments in development/validation (including a dedicated E2E team)
and heroic effort by many across all levels of development, validation, and customer enabling.  

To successfully deliver the vision that the market is looking for, we need:

**Inside Intel**: an easy to run set of common smoke tests that the long list of component development+validation teams can easily add
to what they are currently doing.  The intent is to provide a testable definition of marketing claims which historically have been too
high level for technical teams to consider in their day-to-day work and release preparation.  Since the work of many teams must 
integrate to this common definition we need something to enforce this definition of what is expected to work in an unambiguous/automatable
way or details get lost very quickly.  This does not add work to busy development/validation teams -- overall this project is expected 
to reduce validation complexity since teams can focus on specific features they are responsible for without over-testing ambiguous scope boundaries.
This project will give teams better assurance that their work is not breaking things downstream.

**For customers**: Customers need a way to quickly check that their system is set up correctly. 

**For both**:  Clarity about what is expected to work means more efficiency for everyone.  

Challenges: 
 - composable stack definitions in metapackages.  See https://github.com/intel-sandbox/jpk.package-test/blob/main/docs/meta-packages.md
 - cross-team alignment.  Need to get buy-in from multiple projects to use these tests.  Also must navigate what each team believes they own so that this project will be seen as adding value vs. simply duplicating effort.


Coverage/Intended Scope       
-----------------------

The scope of what we are claiming will work together includes:

 #. intel-gpu-media (media driver, libva, VPL)
 #. Additional graphics APIs (Vulkan, OpenGL, ...)
 #. Media frameworks + VPL plugins (FFmpeg *_qsv codecs and GStreamer MediaSDK plugin)
 #. intel-gpu-compute and projects that work on top of it (oneAPI, OpenVINO, ITEX, IPEX)


This project provides a set of basic command lines runnable by internal teams and customers to evaluate if their environment is 
set up correctly to support our interoperability claims.  

As smoke tests we simply check for crash, empty output, etc.  More sophisticated tests can be added as interoperability improves.

KPIs are out of scope.  They could be added but we don't want to disrupt any current KPI ownership or HW program milestones. 


Supported Hardware
------------------

Project currently supports Xe and newer GPUs, including Intel(r) Arc(tm) A-series.
(Not tested yet on Flex, but Arc is assumed to be a reasonable proxy)


Setup Steps
------------

Run setup/setup.sh on test system, bare metal Ubuntu 22.04 or in fresh Docker Ubuntu 22.04 container.

Note: setup steps are for bootstrapping only.  Purpose of the customer runnable steps is to test the installed stack.


How to Run Tests
----------------


Contributing
------------

Feedback and contributions are welcome. Please, submit
 - **issues** https://github.com/jeffreymcallister/customer_runnable_smoke_tests/issues
 - **pull requests** https://github.com/jeffreymcallister/customer_runnable_smoke_tests/pulls

