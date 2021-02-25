all:  getimage setconf

getimage: getimage.cpp sharedmem.cpp
	$(CXX) $(LDFLAG) -o $@ $^ $(LIBS) -lpthread -lm -lrt
	$(STRIP) $@

setconf: setconf.cpp sharedmem.cpp
	$(CXX) $(LDFLAG) -o $@ $^ $(LIBS) -lpthread -lm -lrt
	$(STRIP) $@



%.o:%.c sample-common.h
	$(CC) -c $(CFLAGS) $< -o $@

%.o:%.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@


clean:
	rm -f *.o *~

distclean: clean
	rm -f $(SAMPLES)
