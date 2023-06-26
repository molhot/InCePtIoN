NAME = inception
COMPOSE_FILE = docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

VOLUME_DIR			= /home/satushi/data

WP_CONTENT_VOLUME	= $(VOLUME_DIR)/wordpress
WP_DB_VOLUME		= $(VOLUME_DIR)/mariadb

all: $(NAME)

$(NAME): $(COMPOSE_FILE) create_volumes
		$(COMPOSE) up -d --build

#mkdir $(WP_CONTENT_VOLUME) $(WP_DB_VOLUME)
create_volumes:
	mkdir -p $(WP_CONTENT_VOLUME) $(WP_DB_VOLUME)

down:
	$(COMPOSE) down

#docker system prune -a --force --volumes
#停止しているコンテナ、未使用のイメージ、未使用のネットワーク、および未使用のボリュームを削除します
#-aオプションは、停止しているコンテナと未使用のイメージを対象にします
#--forceオプションは、確認なしでクリーンアップ操作を実行します
#--volumesオプションは、未使用のボリュームも削除します

#docker network prune --force
#未使用のDockerネットワークを削除します
#Dockerコンテナやサービスが終了した後に使用されなくなったネットワークがある場合
#これによりそれらのネットワークが削除されます

fclean: down
	docker system prune -a --force --volumes
	docker network prune --force
	docker volume prune --force

re: fclean all

exec_nginx:
	docker exec -it nginx sh

rm_nginx:
	$(COMPOSE) stop nginx
	$(COMPOSE) rm nginx

rm_mariadb:
	$(COMPOSE) stop db
	$(COMPOSE) rm db

ps:
	docker ps -a

im:
	docker image ls -a