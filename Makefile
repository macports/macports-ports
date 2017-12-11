PORTS_FILE:=				ports.txt
LOCAL_PORTS_DIR:=		~/ports

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

.PHONY: port-index
port-index:
	@(cd $(LOCAL_PORTS_DIR) ; portindex )
