.POSIX:

ENVIRONMENT = PATH=$$(realpath oss-cad-suite/bin):$$PATH
FPGA = build/tt_um_mastensg_ttsky26a_demo.bin
SOURCES = src/project.v src/snow.v

all: $(FPGA)

check:
	verilator --lint-only $(SOURCES)

clean:
	rm -rf build

distclean:
	rm -rf oss-cad-suite pit tt

$(FPGA): $(SOURCES)
	$(ENVIRONMENT) pit/bin/python3 tt/tt_fpga.py harden
	cat build/*.log | grep -i warn

load: all
	$(ENVIRONMENT) pit/bin/python3 tt/tt_fpga.py configure --upload --set-default --clockrate 25000000

setup:
	[ -f oss-cad-suite-linux-*.tgz	] || wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-04-21/oss-cad-suite-linux-x64-20260421.tgz
	[ -d tt				] || git clone https://github.com/TinyTapeout/tt-support-tools tt
	[ -d oss-cad-suite		] || tar xf oss-cad-suite-linux-x64-20260421.tgz
	[ -d pit			] || python3 -m venv pit
	pit/bin/pip install -r tt/requirements.txt

.PHONY: all check clean distclean load setup
