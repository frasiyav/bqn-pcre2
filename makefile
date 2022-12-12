CFLAGS = -fPIC -shared

all: UTF8 UTF16 UTF32

UTF8:
	cc $(CFLAGS) bqn-pcre2.c -DUTF8 -lpcre2-8 -o bqn-pcre2-8.so

UTF16:
	cc $(CFLAGS) bqn-pcre2.c -DUTF16 -lpcre2-16 -o bqn-pcre2-16.so

UTF32:
	cc $(CFLAGS) bqn-pcre2.c -DUTF32 -lpcre2-32 -o bqn-pcre2-32.so

clean:
	rm -f *.so
