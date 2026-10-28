# config.m4

AC_DEFUN([_WI_MSG_LIB_ERROR], [
	AC_MSG_ERROR([could not locate $1

If you installed $1 into a non-standard directory, please run:

    env CPPFLAGS="-I/path/to/include" LDFLAGS="-L/path/to/lib" ./configure])
])


AC_DEFUN([WI_APPEND_FLAG], [
	if test -z "$$1"; then
		$1="$2"
	else
		MATCH=`expr -- "$$1" : ".*$2"`

		if test "$MATCH" = "0"; then
			$1="$$1 $2"
		fi
	fi
])


AC_DEFUN([WI_CHECK_SVN_REVISION], [
	WI_REVISION=$(cat version)
	
	if test -z "$WI_REVISION"; then
		WI_REVISION=0
	fi

	AC_DEFINE_UNQUOTED([WI_REVISION], "$WI_REVISION", [Subversion revision])
])


AC_DEFUN([WI_INCLUDE_WARNING_FLAG], [
	OLD_CFLAGS="$CFLAGS"
	WI_APPEND_FLAG([CFLAGS], $1)

	AC_COMPILE_IFELSE([AC_LANG_SOURCE([
		int main() {
			return 0;
		}
	])], [
		WI_APPEND_FLAG([WARNFLAGS], $1)
	], [
		CFLAGS="$OLD_CFLAGS"
	])
])


AC_DEFUN([WI_INCLUDE_EXTRA_INCLUDE_PATHS], [
	if test "$wi_include_extra_include_paths_done" != "yes"; then
		if test -d __PREFIX__/include; then
			WI_APPEND_FLAG([CPPFLAGS], [-I__PREFIX__/include])
		fi

		if test -d __PREFIX__/include/wired; then
			WI_APPEND_FLAG([CPPFLAGS], [-I__PREFIX__/include/wired])
		fi
		
		wi_include_extra_include_paths_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_EXTRA_LIBRARY_PATHS], [
	if test "$wi_include_extra_library_paths_done" != "yes"; then
		if test -d __PREFIX__/lib; then
			WI_APPEND_FLAG([LDFLAGS], [-L__PREFIX__/lib])
		fi
		
		wi_include_extra_library_paths_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_EXTRA_SSL_PATHS], [
	if test "$wi_include_extra_ssl_paths_done" != "yes"; then
		if test -d __PREFIX__/ssl/include; then
			WI_APPEND_FLAG([CPPFLAGS], [-I__PREFIX__/ssl/include])
		fi

		if test -d __PREFIX__/kerberos/include; then
			WI_APPEND_FLAG([CPPFLAGS], [-I__PREFIX__/kerberos/include])
		fi

		if test -d __PREFIX__/ssl/lib; then
			WI_APPEND_FLAG([LDFLAGS], [-__PREFIX__/ssl/lib])
		fi

		wi_include_extra_ssl_paths_done="yes"
	fi
])



AC_DEFUN([WI_INCLUDE_LIBWIRED_LIBRARIES], [
	WI_INCLUDE_MATH_LIBRARY
	WI_INCLUDE_SOCKET_LIBRARY
	WI_INCLUDE_NSL_LIBRARY
	WI_INCLUDE_RESOLV_LIBRARY
	WI_INCLUDE_CORESERVICES_FRAMEWORK
	WI_INCLUDE_CARBON_FRAMEWORK
	WI_INCLUDE_COMMON_CRYPTO_LIBRARIES
])


AC_DEFUN([WI_INCLUDE_OPENSSL_LIBRARIES], [
	WI_INCLUDE_CRYPTO_LIBRARY
	WI_INCLUDE_SSL_LIBRARY
])


AC_DEFUN([WI_INCLUDE_COMMON_CRYPTO_LIBRARIES], [
	AC_CHECK_HEADERS([ \
		CommonCrypto/CommonDigest.h \
		CommonCrypto/CommonCryptor.h \
	], [
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_DIGESTS])
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_CIPHERS])
		m4_ifvaln([$1], [$1], [:])
	], [
		m4_ifvaln([$2], [$2], [:])
	])
])


AC_DEFUN([WI_INCLUDE_P7_LIBRARIES], [
	WI_INCLUDE_COMMON_CRYPTO_LIBRARIES([], [
		WI_INCLUDE_CRYPTO_LIBRARY
	])
	
	WI_INCLUDE_CRYPTO_LIBRARY([noerror])
	WI_INCLUDE_LIBXML2_LIBRARY
	WI_INCLUDE_ZLIB_LIBRARY

	WI_APPEND_FLAG([CPPFLAGS], [-DWI_P7])
])


AC_DEFUN([WI_INCLUDE_MATH_LIBRARY], [
	if test "$wi_include_math_library_done" != "yes"; then
		AC_CHECK_FUNC([pow], [], [
			AC_CHECK_LIB([m], [sqrt], [
				WI_APPEND_FLAG([LIBS], [-lm])
			])
		])
		
		wi_include_math_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_SOCKET_LIBRARY], [
	if test "$wi_include_socket_library_done" != "yes"; then
		AC_CHECK_FUNC(setsockopt, [], [
			AC_CHECK_LIB([socket], [setsockopt], [
				WI_APPEND_FLAG([LIBS], [-lsocket])
			])
		])
		
		wi_include_socket_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_NSL_LIBRARY], [
	if test "$wi_include_nsl_library_done" != "yes"; then
		AC_CHECK_FUNC([gethostent], [], [
			AC_CHECK_LIB([nsl], [gethostent], [
				WI_APPEND_FLAG([LIBS], [-lnsl])
			])
		])
		
		wi_include_nsl_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_RESOLV_LIBRARY], [
	if test "$wi_include_resolv_library_done" != "yes"; then
		AC_CHECK_FUNC([herror], [], [
			AC_CHECK_LIB([resolv], [herror], [
				WI_APPEND_FLAG([LIBS], [-lresolv])
			])
		])
		
		wi_include_resolv_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_CRYPTO_LIBRARY], [
	if test "$wi_include_crypto_library_done" != "yes"; then
		WI_INCLUDE_EXTRA_SSL_PATHS

		AC_CHECK_HEADERS([openssl/sha.h], [], [
			if test "$1" != "noerror"; then
				_WI_MSG_LIB_ERROR([OpenSSL])
			fi
		])
		
		AC_CHECK_LIB([crypto], [SHA1_Init], [
			WI_APPEND_FLAG([LIBS], [-lcrypto])
			WI_APPEND_FLAG([CPPFLAGS], [-DWI_DIGESTS])
			WI_APPEND_FLAG([CPPFLAGS], [-DWI_CIPHERS])
			WI_APPEND_FLAG([CPPFLAGS], [-DWI_RSA])
		], [
			if test "$1" != "noerror"; then
				_WI_MSG_LIB_ERROR([OpenSSL])
			fi
		])

		wi_include_crypto_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_SSL_LIBRARY], [
	if test "$wi_include_ssl_library_done" != "yes"; then
		WI_INCLUDE_EXTRA_SSL_PATHS

		AC_CHECK_HEADERS([openssl/ssl.h], [], [
			if test "$1" != "noerror"; then
				_WI_MSG_LIB_ERROR([OpenSSL])
			fi
		])

		AC_CHECK_LIB([ssl], [SSL_SESSION_new], [
			WI_APPEND_FLAG([LIBS], [-lssl])
			WI_APPEND_FLAG([CPPFLAGS], [-DWI_SSL])
		], [
			if test "$1" != "noerror"; then
				_WI_MSG_LIB_ERROR([OpenSSL])
			fi
		])

		wi_include_ssl_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_CORESERVICES_FRAMEWORK], [
	if test "$wi_include_coreservices_framework_done" != "yes"; then
		AC_CHECK_HEADERS([CoreServices/CoreServices.h], [
			WI_APPEND_FLAG([LIBS], [-framework CoreServices])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_CORESERVICES])
		
		wi_include_coreservices_framework_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_CARBON_FRAMEWORK], [
	if test "$wi_include_carbon_framework_done" != "yes"; then
		AC_CHECK_HEADERS([Carbon/Carbon.h], [
			WI_APPEND_FLAG([LIBS], [-framework Carbon])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_CARBON])
		
		wi_include_carbon_framework_done="yes"
	fi
])


AC_DEFUN([_WI_PTHREAD_TEST_INCLUDES], [
	#include <pthread.h>
	#include <errno.h>

	void * thread(void *arg) {
		return NULL;
	}
])


AC_DEFUN([_WI_PTHREAD_TEST_FUNCTION], [
	pthread_t tid;

	if(pthread_create(&tid, 0, thread, NULL) < 0)
		return errno;

	return 0;
])


AC_DEFUN([_WI_PTHREAD_TEST_PROGRAM], [
	_WI_PTHREAD_TEST_INCLUDES

	int main(void) {
		_WI_PTHREAD_TEST_FUNCTION
	}
])


AC_DEFUN([_WI_PTHREAD_TRY], [
	if test "$wi_pthreads_found" != "yes"; then
		OLD_LIBS="$LIBS"
		WI_APPEND_FLAG([LIBS], $1)

		AC_RUN_IFELSE([AC_LANG_SOURCE([_WI_PTHREAD_TEST_PROGRAM])], [
			wi_pthreads_test=yes
		], [
			wi_pthreads_test=no
		], [
			AC_LINK_IFELSE([AC_LANG_PROGRAM([_WI_PTHREAD_TEST_INCLUDES], [_WI_PTHREAD_TEST_FUNCTION])], [
				wi_pthreads_test=yes
			], [
				wi_pthreads_test=no
			])
		])

		LIBS="$OLD_LIBS"

		if test "$wi_pthreads_test" = "yes"; then
			wi_pthreads_found="yes"
			wi_pthreads_libs="$1"
		fi
	fi
])


AC_DEFUN([WI_INCLUDE_PTHREADS], [
	if test "$wi_include_pthreads_done" != "yes"; then
		case $host in
			*-solaris*)
				AC_DEFINE([_POSIX_PTHREAD_SEMANTICS], [], [Define on Solaris to get sigwait() to work using pthreads semantics.])
				;;
		esac
		
		AC_CHECK_HEADERS([pthread.h], [
			AC_MSG_CHECKING([for pthreads])

			_WI_PTHREAD_TRY([])
			_WI_PTHREAD_TRY([-pthread])
			_WI_PTHREAD_TRY([-lpthread])

			if test "$wi_pthreads_found" = "yes"; then
				AC_MSG_RESULT([yes])
				WI_APPEND_FLAG([LIBS], $wi_pthreads_libs)
			else
				AC_MSG_RESULT([no])
				AC_MSG_ERROR([could not locate pthreads])
			fi
		], [
			AC_MSG_ERROR([could not locate pthreads])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_PTHREADS])

		wi_include_pthreads_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_ICONV_LIBRARY], [
	if test "$wi_include_iconv_library_done" != "yes"; then
		AC_CHECK_HEADERS([iconv.h], [], [
			_WI_MSG_LIB_ERROR([iconv])
		])

		AC_CHECK_LIB([iconv], [iconv], [
			WI_APPEND_FLAG([LIBS], [-liconv])
		], [
			AC_CHECK_LIB([iconv], [libiconv], [
				WI_APPEND_FLAG([LIBS], [-liconv])
			], [
				AC_CHECK_FUNC([iconv], [], [
					_WI_MSG_LIB_ERROR([iconv])
				])
			])
		])

		AC_MSG_CHECKING([if iconv understands Unicode])
		AC_RUN_IFELSE([AC_LANG_SOURCE([
			#include <iconv.h>
			int main(void) {
				iconv_t conv = iconv_open("UTF-8", "UTF-16");
				if(conv == (iconv_t) -1)
					return 1;
				return 0;
			}
		])], [
			AC_MSG_RESULT([yes])
		], [
			AC_MSG_ERROR([no])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_ICONV])

		wi_include_iconv_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_TERMCAP_LIBRARY], [
	if test "$wi_include_termcap_library_done" != "yes"; then
		AC_CHECK_HEADERS([ \
			curses.h \
			term.h \
			termcap.h \
			termios.h \
		], [
			AC_CHECK_FUNC([tgoto], [], [
				AC_CHECK_LIB([termcap], [tgoto], [
					WI_APPEND_FLAG([LIBS], [-ltermcap])
				], [
					AC_CHECK_LIB([ncurses], [tgoto], [
						WI_APPEND_FLAG([LIBS], [-lncurses])
					], [
						AC_CHECK_LIB([curses], [tgoto], [
							WI_APPEND_FLAG([LIBS], [-lcurses])
						])
					])
				])
			])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_TERMCAP])

		wi_include_termcap_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_READLINE_LIBRARY], [
	if test "$wi_include_readline_library_done" != "yes"; then
		AC_CHECK_HEADERS([readline/readline.h], [], [
			_WI_MSG_LIB_ERROR([readline])
		])
		
		AC_CHECK_LIB([readline], [rl_initialize], [
			WI_APPEND_FLAG([LIBS], [-lreadline])

			AC_MSG_CHECKING([for GNU readline])
			AC_RUN_IFELSE([AC_LANG_SOURCE([
				#include <stdio.h>
				#include <readline/readline.h>
				int main(void) {
					return rl_gnu_readline_p ? 0 : 1;
				}
			])], [
				AC_MSG_RESULT([yes])
			], [
				AC_MSG_RESULT([no])
				_WI_MSG_LIB_ERROR([GNU readline])
			])

			AC_MSG_CHECKING([for rl_completion_matches])
			AC_RUN_IFELSE([AC_LANG_SOURCE([
				#include <stdio.h>
				#include <readline/readline.h>
				char * generator(const char *, int);
				char * generator(const char *text, int state) {
					return NULL;
				}
				int main(void) {
					(void) rl_completion_matches("", generator);

					return 0;
				}
			])], [
				AC_DEFINE([HAVE_RL_COMPLETION_MATCHES], [1], [Define to 1 if you have the `rl_completion_matches' function, and to 0 otherwise.])
				AC_MSG_RESULT([yes])

			], [
				AC_MSG_RESULT([no])
			])

			AC_CHECK_DECLS([rl_completion_display_matches_hook], [], [], [
				#include <stdio.h>
				#include <readline/readline.h>
			])
		], [
			_WI_MSG_LIB_ERROR([readline])
		])

		WI_APPEND_FLAG([CPPFLAGS], [-DWI_READLINE])
		
		wi_include_readline_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_LIBXML2_LIBRARY], [
	if test "$wi_include_libxml2_library_done" != "yes"; then
		if test -d __PREFIX__/include/libxml2; then
			WI_APPEND_FLAG([CPPFLAGS], [-I__PREFIX__/include/libxml2])
		fi

		AC_CHECK_HEADERS([libxml/parser.h], [], [
			_WI_MSG_LIB_ERROR([libxml2])
		])
		
		AC_CHECK_LIB([xml2], [xmlParseFile], [
			WI_APPEND_FLAG([LIBS], [-lxml2])
		], [
			_WI_MSG_LIB_ERROR([libxml2])
		])

		WI_APPEND_FLAG([CPPFLAGS], [-DWI_LIBXML2])
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_PLIST])

		wi_include_libxml2_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_ZLIB_LIBRARY], [
	if test "$wi_include_zlib_library_done" != "yes"; then
		AC_CHECK_HEADERS([zlib.h], [], [
			_WI_MSG_LIB_ERROR([zlib])
		])
		
		AC_CHECK_LIB([z], [deflate], [
			WI_APPEND_FLAG([LIBS], [-lz])
		], [
			_WI_MSG_LIB_ERROR([zlib])
		])

		WI_APPEND_FLAG([CPPFLAGS], [-DWI_ZLIB])
		
		wi_include_zlib_library_done="yes"
	fi
])


AC_DEFUN([WI_INCLUDE_SQLITE3_LIBRARY], [
	if test "$wi_include_sqlite3_library_done" != "yes"; then
		AC_CHECK_HEADERS([sqlite3.h], [], [
			_WI_MSG_LIB_ERROR([sqlite3])
		])
		
		AC_CHECK_LIB([sqlite3], [sqlite3_open], [
			WI_APPEND_FLAG([LIBS], [-lsqlite3])
		], [
			_WI_MSG_LIB_ERROR([sqlite3])
		])

		AC_CHECK_LIB([sqlite3], [sqlite3_backup_init], [
			AC_DEFINE_UNQUOTED([WI_SQLITE_SUPPORTS_BACKUP], [1], [SQLite supports backup])
		], [
			AC_DEFINE_UNQUOTED([WI_SQLITE_SUPPORTS_BACKUP], [0], [SQLite does not support backup])
		])
		
		WI_APPEND_FLAG([CPPFLAGS], [-DWI_SQLITE3])
		
		wi_include_sqlite3_library_done="yes"
	fi
])
