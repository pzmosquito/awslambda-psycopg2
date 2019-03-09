SSL ?= 0

.PHONY:	build
build:
	@docker build --force-rm --build-arg SSL=$(SSL) -t awslambda-psycopg2 .

.PHONY: run
run:
	@echo "starting container..."
	@docker run --rm -t -d --name psycopg2 awslambda-psycopg2 > /dev/null
	@echo "done"
	
	@echo "coping library to build directory..."
	@rm -rf build >/dev/null
	@docker cp psycopg2:/sources/psycopg2/build build > /dev/null
	@echo "done"
	
	@echo "stopping container..."
	@docker stop psycopg2 > /dev/null
	@echo "done"

.PHONY: clean
clean:
	@echo "deleting image..."
	@docker rmi awslambda-psycopg2 > /dev/null
	@echo "done"