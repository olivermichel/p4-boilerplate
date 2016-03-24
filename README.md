# p4-boilerplate

A starting point for [P4](http://www.p4lang.org) projects using the P4 behavioral model version 2.

## Installing Prerequisites

### 1. Install the [behavioral model](https://github.com/p4lang/behavioral-model)

	git clone https://github.com/p4lang/behavioral-model.git bmv2
	cd bmv2
	./install_deps.sh
	./autogen.sh
	./configure
	make

### 2. Install the [BM compiler](https://github.com/p4lang/p4c-bm)

	git clone https://github.com/p4lang/p4c-bm.git p4c-bmv2
	sudo pip install -r requirements.txt
	sudo python setup.py install

### 3. Compile the project. It is imperative to change the *P4_BM_DIR* variable in the Makefile to
the path where the behavioral model was installed.

	make

## Run the Code using Mininet

	sudo ./1sw_demo.py --behavioral-exe simple_router --json simple_router.json
