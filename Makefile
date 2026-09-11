.PHONY: setup core ipa-unsigned verify-ipa test

setup:
	./Scripts/setup.sh

core:
	./Scripts/build-core.sh

ipa-unsigned: core
	./Scripts/build-unsigned-ipa.sh

verify-ipa:
	@test -n "$(IPA)" || (echo "Usage: make verify-ipa IPA=/absolute/path/to/signed.ipa" >&2; exit 2)
	./Scripts/verify-ipa.sh --signed "$(IPA)"

test:
	./Tests/run_all_contract_tests.sh
