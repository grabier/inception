COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DATA_DIR = ~/data
VOLUMES = db-data wp-data

all: prepare build up

prepare:
	mkdir -p $(DATA_DIR)
	for vol in $(VOLUMES); do \
		mkdir -p $(DATA_DIR)/$$vol; \
	done

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	docker stop $$(docker ps -aq) 2>/dev/null || echo "No containers running"
	docker rm -rf $$(docker ps -aq) 2>/dev/null || echo "No containers to remove"
	docker volume rm $$(docker volume ls -q)  2>/dev/null || echo "No volumes to remove"
	docker network rm $$(docker network ls -q) | grep -vE "bridge|host|none"  2>/dev/null || echo "No network to remove"
	rm -rf $(DATA_DIR) || echo "No data to delete"

fclean: clean
	docker rmi -f $$(docker images -q)  2>/dev/null || echo "No images built"
	docker system prune -af --volumes

re: fclean all

.PHONY: all prepare build up down clean fclean re
