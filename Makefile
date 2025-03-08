.PHONY: build
build:
	@echo "Baking build..."
	docker buildx bake

.PHONY: test
test: build
	@echo "Testing bake..."
	docker buildx bake test

.PHONY: lint
lint: build
	@echo "Baking pretty..."
	docker buildx bake lint