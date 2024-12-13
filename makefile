.PHONY: build

all: clean jazzy

jazzy:
	$(MAKE) build \
		ros_distro=$@

humble:
	$(MAKE) build \
		ros_distro=$@

define build_image
	docker buildx build \
		-f ./dockerfile \
		--build-arg ros_distro=$(ros_distro) \
		--platform linux/arm64 \
		-t netizen-robotics-ros2-$(ros_distro) .
	docker image save netizen-robotics-ros2-$(ros_distro) > images/netizen-robotics-ros2-$(ros_distro).zip
endef

build:
	$(call build_image,robot)

clean:
	rm -rf images/*