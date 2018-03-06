clean:
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "*.DS_Store" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name "*.cache" -type d | xargs rm -rf
	@find . -name "*htmlcov" -type d | xargs rm -rf
	@rm -f .coverage
	@rm -f coverage.xml


run:
	./manager.py runserver --reload --debug


requirements-dev:
	pip install -r requirements-dev.txt


test: clean
	nosetests -s --rednose

coverage: clean
	nosetests --with-coverage --cover-package=sfd
