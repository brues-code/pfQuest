GITREV = $(shell git describe --tags)

all: clean stripdb full enUS koKR frFR deDE zhCN esES ruRU ptBR

clean:
	rm -rfv release

stripdb:
	toolbox/compressdb.sh

full:
	$(eval LOCALE := $(shell echo $@))
	@echo "===== building ${LOCALE} ====="
	mkdir -p release/$@/pfQuest/
	cp -rf compat db img init *.toc *.lua LICENSE README.md release/$@/pfQuest/

	# generate new toc file
	echo $(GITREV) > release/$@/pfQuest/gitrev.txt
	( cd release/$@; zip -9qr ../pfQuest-$@.zip pfQuest )

enUS koKR frFR deDE zhCN esES ruRU ptBR:
	$(eval LOCALE := $(shell echo $@))
	@echo "===== building ${LOCALE} ====="
	mkdir -p release/$@/pfQuest/init release/$@/pfQuest/db/enUS release/$@/pfQuest/db/${LOCALE}
	cp -rf compat img release/$@/pfQuest/

	cp -f $(shell ls db/*.lua) release/$@/pfQuest/db
	cp -f $(shell ls db/enUS/*.lua) release/$@/pfQuest/db/enUS
	cp -f $(shell ls db/${LOCALE}/*.lua) release/$@/pfQuest/db/${LOCALE}
	cp -f *.lua LICENSE README.md release/$@/pfQuest/
	cp -f init/addon.xml init/data.xml init/enUS.xml init/${LOCALE}.xml release/$@/pfQuest/init
	cp -f pfQuest.toc release/$@/pfQuest/pfQuest.toc
	cp -f pfQuest_ClassicAPI.toc release/$@/pfQuest/pfQuest_ClassicAPI.toc

	# pfQuest.toc is a ClassicAPI-less stub with no init lines, so it ships as-is.
	# Slim the ClassicAPI load list (the redirect target) to this locale's files.
	sed -i '/init\\/d' release/$@/pfQuest/pfQuest_ClassicAPI.toc
	sed -i '/^[[:space:]]*$$/d' release/$@/pfQuest/pfQuest_ClassicAPI.toc
	/bin/echo 'init\data.xml' >> release/$@/pfQuest/pfQuest_ClassicAPI.toc
	/bin/echo 'init\enUS.xml' >> release/$@/pfQuest/pfQuest_ClassicAPI.toc
	/bin/echo 'init\$(LOCALE).xml' >> release/$@/pfQuest/pfQuest_ClassicAPI.toc
	/bin/echo 'init\addon.xml' >> release/$@/pfQuest/pfQuest_ClassicAPI.toc

	echo $(GITREV) > release/$@/pfQuest/gitrev.txt
	( cd release/$@; zip -9qr ../pfQuest-$@.zip pfQuest )

database:
	$(MAKE) -C toolbox/ all

rebuild: database all

locales:
	toolbox/find_locales.sh
