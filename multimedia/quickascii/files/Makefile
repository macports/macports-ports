all: quickascii

OBJS = commands.o qtplyr.o

commands.o: commands.c
	$(CC) -c $< -o $@

qtplyr.o: qtplyr.c commands.o
	$(CC) -c $< -o $@

quickascii: $(OBJS)
	$(CC) $(OBJS) -o $@ -framework QuickTime -framework Carbon

clean:
	@rm -f qtplyr.o commands.o quickascii

.PHONY: all clean
