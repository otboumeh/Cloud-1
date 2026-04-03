COMPOSE_FILE = docker-compose.yml
DATA_PATH = /home/otmane/data

# Volvemos al comando con guion que es el estándar en estas VMs
DOCKER_COMPOSE = docker-compose -f $(COMPOSE_FILE)

GREEN = \033[0;32m
RED   = \033[0;31m
YELLOW = \033[0;33m
RESET = \033[0m

all:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "$(GREEN)Building Inception...$(RESET)"
	@$(DOCKER_COMPOSE) up -d --build

up:
	@$(DOCKER_COMPOSE) up -d

down:
	@$(DOCKER_COMPOSE) down

clean:
	@printf "$(RED)Cleaning Containers & Images ... $(RESET)"
	@$(DOCKER_COMPOSE) down --volumes --rmi all
	@echo "$(GREEN)✅$(RESET)"

fclean: clean
	@printf "$(RED)Cleaning Volumes & Persistent Data ... $(RESET)"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@docker system prune -a --volumes -f > /dev/null
	@echo "$(GREEN)✅$(RESET)"
	@echo "$(RED)Deep clean complete.$(RESET)"

re: fclean all

ansible:
	@if ! command -v ansible-playbook > /dev/null; then \
		echo "Ansible no está instalado. Instalando mediante Homebrew..."; \
		brew install ansible; \
	fi
@echo "Ejecutando Ansible..."
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory.ini ../ansible/site.yml

status:
	@docker ps
	@docker volume ls

logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: all up down clean fclean re status logs ansible
