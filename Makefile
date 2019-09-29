deploy:
	mix edeliver build release production && mix edeliver deploy release to production	

deploy-fast:
	mix edeliver build release production --skip-git-clean --skip-mix-clean	&& mix edeliver deploy release to production	

restart:
	mix edeliver restart production
