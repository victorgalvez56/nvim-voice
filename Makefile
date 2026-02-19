APP_NAME = NvimVoice
APP_BUNDLE = $(APP_NAME).app
SIGN_ID = Apple Development: Victor Galvez (7BVX533M64)

.PHONY: dev watch build bundle run install clean

# Dev: debug build + relaunch app bundle (~2-5s incremental)
dev:
	@swift build 2>&1 | tail -5
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@cp .build/debug/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	@codesign --force --sign "$(SIGN_ID)" --entitlements NvimVoice/Resources/NvimVoice.entitlements $(APP_BUNDLE)
	@pkill -x $(APP_NAME) 2>/dev/null || true
	@sleep 0.3
	@open $(APP_BUNDLE)
	@echo "✅ dev ready"

# Watch: auto-rebuild + relaunch on any .swift change
watch:
	@echo "👀 Watching for changes... (Ctrl+C to stop)"
	@make dev 2>&1 || true
	@fswatch -o -e ".*" -i "\\.swift$$" NvimVoice/ | while read; do \
		echo "🔄 Change detected, rebuilding..."; \
		make dev 2>&1 || echo "❌ Build failed"; \
	done

# Release build
build:
	swift build -c release

bundle: build
	mkdir -p $(APP_BUNDLE)/Contents/MacOS
	mkdir -p $(APP_BUNDLE)/Contents/Resources
	cp .build/release/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	codesign --force --sign "$(SIGN_ID)" --entitlements NvimVoice/Resources/NvimVoice.entitlements $(APP_BUNDLE)
	@echo "✅ $(APP_BUNDLE) ready"

run: bundle
	open $(APP_BUNDLE)

install: bundle
	cp -R $(APP_BUNDLE) /Applications/$(APP_BUNDLE)
	@echo "✅ Installed to /Applications/$(APP_BUNDLE)"

clean:
	swift package clean
	rm -rf $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
