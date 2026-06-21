.PHONY: deps lint test run docker_build docker_push docker_run

USERNAME ?= mariuszjanowiak
IMAGE_NAME=hello-world-printer-k7-2026
TAG=$(USERNAME)/$(IMAGE_NAME)

deps:
	python -m pip install -r requirements.txt
	python -m pip install -r test_requirements.txt

lint:
	python -m flake8 hello_world test

run:
	python main.py

test:
	python -m pytest --verbose -s

docker_build:
	docker build -t $(IMAGE_NAME) .

docker_push: docker_build
	@echo "$${DOCKER_PASSWORD}" | docker login --username "$(USERNAME)" --password-stdin; \
	docker tag $(IMAGE_NAME) $(TAG); \
	docker push $(TAG); \
	docker logout;

docker_run: docker_build
	docker run --name hello-world-printer-dev -p 5000:5000 -d $(IMAGE_NAME)