AUTO_VERSION=git-revision+commit-count
RELEASE_VERSION=git-revision+commit

build:
	mix edeliver build release production --skip-git-clean --auto-version=commit-count+git-revision
	
deploy:
	mix edeliver deploy release to production	

deploy-fast:
	mix edeliver build release production --skip-git-clean --skip-mix-clean	&& mix edeliver deploy release to production	

restart:
	mix edeliver restart production

upgrade:
	mix edeliver upgrade --auto-version=commit-count+git-revision --skip-git-clean
