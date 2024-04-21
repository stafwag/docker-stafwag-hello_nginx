# Makefile for OpenShift local (code ready containers)
.PHONY: 
crc_deps:
	which oc
	which podman
	which helm

.PHONY: crc_project
crc_project: crc_deps
	@echo "Creating project: $(K8S_NS)"
	oc get ns $(K8S_NS) || oc new-project $(K8S_NS) 

.PHONY: crc_project
clean: crc_deps
	@echo "Destroying project: $(K8S_NS)"
	oc delete project $(K8S_NS) 
