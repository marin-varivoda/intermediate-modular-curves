# make check   - check that every claim in data/ is backed by a saved passing log or a citation (seconds)
# make verify  - rerun the certificates that take minutes rather than hours, writing all output to build/verify/
#                (the saved logs are not touched), and fail if any of them fails. Needs Magma.
#                Theorem A takes 20 to 60 minutes with JOBS=8, depending on the load; the rest takes a few minutes.
# The long computations (the lower bounds of Theorem C, Theorem D) are rerun from their own folders; see their READMEs.

MAGMA ?= magma
JOBS ?= 8
OUT := $(CURDIR)/build/verify
ERRORS := Runtime error|User error|Assertion failed|[Ss]yntax error|FAIL

CUSP := 41.168.11.b.1 41.210.11.b.1 41.420.21.d.1 45.432.21.g.2 49.392.19.i.2
C43 := identify_model torsion_classes audit_smooth_reduction audit_certificate audit_torsion_counts \
       prove_lower_bound_7 prove_upper_bound_7

.PHONY: check verify verify-good-reduction verify-class-e verify-upper verify-43 verify-a

check:
	python3 verify.py

verify: verify-good-reduction verify-class-e verify-upper verify-43 verify-a
	@echo "PASS: all rerun certificates succeeded (outputs in build/verify/)"

$(OUT):
	mkdir -p $(OUT)

# run DIR SCRIPT NAME: run a Magma script in DIR, save its output as $(OUT)/NAME.out, and fail on any error message.
RUN = run() { (cd "$$1" && $(MAGMA) -b "$$2" > "$(OUT)/$$3.out" 2>&1) || { echo "FAIL $$3"; exit 1; }; \
              if grep -E -q "$(ERRORS)" "$(OUT)/$$3.out"; then echo "FAIL $$3"; exit 1; fi; echo "ok $$3"; }

verify-good-reduction: | $(OUT)
	@$(RUN); run certificates good_reduction.m good_reduction; \
	grep -q ALL_67_GOOD_REDUCTION_CHECKS_PASS $(OUT)/good_reduction.out

verify-class-e: | $(OUT)
	@$(RUN); run certificates/B_class_E_degrees modular_degrees.m modular_degrees

verify-upper: | $(OUT)
	@$(RUN); for c in $(CUSP); do run certificates/C_intermediate_gonality/upper/certificates $$c.m upper_$$c; done; \
	for c in 43.308.15.b.1 43.132.9.a.2; do \
	  run certificates/C_intermediate_gonality/upper/special/$$c certificate.m special_$$c; done

verify-43: | $(OUT)
	@$(RUN); for s in $(C43); do run certificates/C_43.132.9.a.2 $$s.m c43_$$s; done

# Theorem A: run.py writes into logs/ next to the code, so it runs on a copy.
verify-a: | $(OUT)
	rm -rf $(OUT)/A_x0_quintic && cp -r certificates/A_x0_quintic $(OUT)/A_x0_quintic
	cd $(OUT)/A_x0_quintic && python3 run.py --jobs $(JOBS) --magma $(MAGMA) > $(OUT)/A_x0_quintic.out 2>&1
	@echo "ok Theorem A (36 certificates)"
