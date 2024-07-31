SRCS=$(wildcard ../../rtl/*.sv)
TBSRCS=$(wildcard ../../tb/sv/src/*.sv)
SIMCOMP := iverilog
SIMCOMP_OPT := -g2012 -gassertions
SIMULATOR :=

VVPS=$(patsubst ../../tb/sv/src/%.sv,%.vvp,$(TBSRCS))

all: run

clean:
	rm -rf $(VVPS) tb.vcd

run: compile
	vvp -v tb.vvp

gui:
	gtkwave tb.vcd &

compile: $(VVPS)

$(VVPS) : %.vvp : $(SRCS) ../../tb/sv/src/%.sv
	$(SIMCOMP) $(SIMCOMP_OPT) -o $@ $^
