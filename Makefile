all: run

env:
	bash ./setup.sh

main-deps: env
	env/bin/pip install -r requirements.txt

run: main-deps
	@bash -c "env/bin/python http_server.py"

clean:
	rm -rf env && find ./ -name "*.pyc" | xargs rm

.PHONY: run
