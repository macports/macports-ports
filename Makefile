PORTS_FILE:=            ports.txt
LOCAL_PORTS_DIR:=       ~/ports
PORT_INDEX_SENTINEL:=   $(LOCAL_PORTS_DIR)/.port-index.sentinel

.PHONY: all
all: create-missing-ports $(PORT_INDEX_SENTINEL)

$(PORT_INDEX_SENTINEL):
	@$(MAKE) port-index
	@touch $@

.PHONY: list-missing-ports
list-missing-ports:
	@for i in $$(cat $(PORTS_FILE)) ; \
	do \
		[[ -d $(LOCAL_PORTS_DIR)/$${i} ]] || echo $${i} ; \
	done

.PHONY: create-missing-ports
create-missing-ports:
	@for i in $$(cat $(PORTS_FILE)) ; \
	do \
		[[ -d $(LOCAL_PORTS_DIR)/$${i} ]] || \
		{ \
			mkdir -p $(LOCAL_PORTS_DIR)/$${i} ; \
			cp -r $${i} $(LOCAL_PORTS_DIR)/$$(dirname $${i}) ; \
			$(RM) $(PORT_INDEX_SENTINEL) ; \
		} \
	done

.PHONY: diff
diff: $(PORTS_FILE) | $(LOCAL_PORTS_DIR)
	@for i in $$(cat $(PORTS_FILE)) ; \
	do \
		diff -r $${i} $(LOCAL_PORTS_DIR)/$${i} || true ; \
	done

.PHONY: delete-local-ports
delete-local-ports:
	@$(RM) -r $(LOCAL_PORTS_DIR)/*
	@$(RM) $(PORT_INDEX_SENTINEL)
	@$(MAKE) $(PORT_INDEX_SENTINEL)

.PHONY: port-index
port-index:
	@(cd $(LOCAL_PORTS_DIR) ; portindex )

.PHONY: livecheck
livecheck:
	@for i in $$(cat $(PORTS_FILE)) ; \
	do \
		port livecheck $${i} ; \
	done

.PHONY: list-ports
list-ports:
	@cat $(PORTS_FILE)
