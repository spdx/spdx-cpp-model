all:
	$(MAKE) -C src/3.0.1

clean:
	$(MAKE) -C src/3.0.1 clean

install:
	$(MAKE) -C src/3.0.1 install

.PHONY: all clean install
