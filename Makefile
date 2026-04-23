.POSIX:

ENVIRONMENT = PATH=$$(realpath oss-cad-suite/bin):$$PATH

SOURCES = src/project.v src/snow.v

all:

check:
	verilator --lint-only $(SOURCES)

distclean:
	rm -rf oss-cad-suite pit tt

fpga:
	$(ENVIRONMENT) pit/bin/python3 tt/tt_fpga.py harden
	cat build/*.log | grep -i warn

load:
	$(ENVIRONMENT) pit/bin/python3 tt/tt_fpga.py configure --upload --set-default --clockrate 25000000

setup:
	[ -f oss-cad-suite-linux-*.tgz	] || wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-04-21/oss-cad-suite-linux-x64-20260421.tgz
	[ -d tt				] || git clone https://github.com/TinyTapeout/tt-support-tools tt
	[ -d oss-cad-suite		] || tar xf oss-cad-suite-linux-x64-20260421.tgz
	[ -d pit			] || python3 -m venv pit
	pit/bin/pip install -r tt/requirements.txt

.PHONY: all check distclean fpga load setup
