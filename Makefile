PRG_NAME=gtkstyleexplorer
VALA_FLAGS = -v
VALA_FLAGS += --disable-warnings
#VALA_FLAGS += -g --save-temps
VALA_FLAGS += -X -DGETTEXT_PACKAGE=\"$(PRG_NAME)\" -X -DVERSION=\"0.2\"
#\ -I.\ -include\ "./config.h" -v
#VALA_FLAGS += --pkg gnome-keyring-1 -D HAVE_QLIST
#VALA_FLAGS += -D ALTERNATE_SCREEN_SCROLL
VALA_FLAGS += --pkg gtk+-3.0 --pkg gdk-x11-3.0 --pkg cairo --pkg posix --pkg gmodule-2.0
#DESTDIR?=
PREFIX?=/usr

VALA_FILES  = main.vala 
#\
#				altyo_hotkey.vala
#				altyo_myoverlaybox.vala

#VALA_FILES  += 	altyo_quick_connectios.vala

default:
	#test -e ./altyo && rm ./altyo
	valac -o $(PRG_NAME) $(VALA_FLAGS) $(VALA_FILES)

source:
	valac -C -H $(VALA_FLAGS)  $(VALA_FILES)

clean:
	rm *.c *.h || true

install: gen_po
	test -z "$(DESTDIR)$(PREFIX)/bin" || mkdir -p "$(DESTDIR)$(PREFIX)/bin";
	cp -a ./$(PRG_NAME) $(DESTDIR)$(PREFIX)/bin
	test -z "$(DESTDIR)$(PREFIX)/share/applications" || mkdir -p "$(DESTDIR)$(PREFIX)/share/applications";
	cp -a ./altyo.desktop $(DESTDIR)$(PREFIX)/share/applications
	test -z "$(DESTDIR)$(PREFIX)/share/locale/ru/LC_MESSAGES" || mkdir -p "$(DESTDIR)$(PREFIX)/share/locale/ru/LC_MESSAGES";
	cp -a ./po/ru/LC_MESSAGES/altyo.mo $(DESTDIR)$(PREFIX)/share/locale/ru/LC_MESSAGES

gen_po:
	xgettext -o ./po/altyo.po --from-code=UTF-8 -language=C -k_ $(VALA_FILES)
	msgmerge -s -U ./po/ru/LC_MESSAGES/$(PRG_NAME).po  ./po/$(PRG_NAME).po
	msgfmt -c -v -o ./po/ru/LC_MESSAGES/$(PRG_NAME).mo ./po/ru/LC_MESSAGES/$(PRG_NAME).po

source-package:
	git-buildpackage --git-upstream-tree=branch --git-upstream-branch=master -rfakeroot -S -sa
