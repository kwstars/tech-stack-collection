delete-submodule:
	@echo "Deleting submodule..."
	@echo "Enter the name of the submodule: "
	@read name; \
	git submodule deinit -f -- $$name; \
	rm -rf .git/modules/$$name; \
	git rm -f $$name
	@echo "Submodule deleted successfully."
