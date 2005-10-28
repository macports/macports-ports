#include <stdlib.h>
#include <string.h>

char *strndup(char *str, size_t len) {
	size_t t;
	char *dest;

	t = strlen(str);
	if (len < t) {
		t = len;
	}
	dest = calloc(t + 1, 1);
	if (NULL != dest) {
		memcpy(dest, str, t);
		dest[t] = '\0';
	}
	return dest;
}

