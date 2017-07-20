.PHONY : gen-relkey
gen-relkey: PRIVATE_KEY_GENERATOR := development/tools/make_key
gen-relkey: PRIVATE_KEY_LOCATION := device/mediatek/common/security/$(MTK_TARGET_PROJECT)
gen-relkey: PRIVATE_KEY_LIST := releasekey media shared platform
gen-relkey: PRIVATE_SIGNATURE_SUBJECT := $(strip $(SIGNATURE_SUBJECT))
gen-relkey:
ifndef MTK_TARGET_PROJECT
  $(error Please specify MTK_TARGET_PROJECT!! Example: make MTK_TARGET_PROJECT=k95v1 -f device/mediatek/build/build/tools/gen_relkey/gen_relkey.mk)
endif
ifndef SIGNATURE_SUBJECT
  $(error Please specify SIGNATURE_SUBJECT!!)
endif
	@ echo "Generating release key/certificate..."
	@ if [ ! -d $(PRIVATE_KEY_LOCATION) ]; then \
                  mkdir $(PRIVATE_KEY_LOCATION); \
                fi
	@ for key in $(PRIVATE_KEY_LIST); do \
                  $(PRIVATE_KEY_GENERATOR) $(strip $(PRIVATE_KEY_LOCATION))/$$key '$(PRIVATE_SIGNATURE_SUBJECT)' < /dev/null; \
                done