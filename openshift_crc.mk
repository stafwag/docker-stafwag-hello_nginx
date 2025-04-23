# Makefile for OpenShift local (code ready containers)
.PHONY: 
crc_deps:
	@echo "Checking for the required dependancies"
	@echo
	which oc
	which podman
	which helm
	@echo "all fine."

.PHONY: crc_project
crc_project: crc_deps
	@echo "Creating project: $(K8S_NS)"
	oc get ns $(K8S_NS) || oc new-project $(K8S_NS) 

.PHONY: crc_get_registry
crc_get_registry: crc_deps
# To get the registry on OpenShift need to have permissions on the openshift-image-regsitry ns
# to get route for the external url. The default developer account doesn't have permissions to do this
# 
# If you run this makefile as an user with the correct permissions you can uncomment the line below.
#	 $(eval REGISTRY := $(shell oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')) 
	#
# Setting the REGISTRY variable manually to allow the default "developer" user to deploy.
	$(eval REGISTRY = default-route-openshift-image-registry.apps-crc.testing)
	@echo "REGISTRY set to $(REGISTRY)"

.PHONY: crc_registry_login
crc_registry_login: crc_deps crc_get_registry
	@echo Trying to log on to $(REGISTRY)
	podman login --tls-verify=false -u $(shell oc whoami) -p $(shell oc whoami -t) --tls-verify=false $(REGISTRY)

.PHONY: crc_deps crc_push
crc_push: crc_deps build crc_project crc_registry_login
	$(eval REMOTE_IMAGE = $(REGISTRY)/$(K8S_NS)/$(IMAGE_NAME):$(GIT_COMMIT_SHORT))
	@echo tagging $(REMOTE_IMAGE)
	podman tag $(LOCAL_IMAGE) $(REMOTE_IMAGE)  
	@echo Push to $(REMOTE_IMAGE)
	podman push --tls-verify=false $(REMOTE_IMAGE)

.PHONY: crc_deploy
crc_deploy: crc_deps crc_push
	helm install --set container.image=$(REMOTE_IMAGE) --set route.enabled="true" -n $(K8S_NS) hello helm/hello-nginx

.PHONY: clean
clean: crc_deps
	@echo "Running: helm unistall"
	helm uninstall hello
	@echo "Destroying project: $(K8S_NS)"
	oc delete project $(K8S_NS)
