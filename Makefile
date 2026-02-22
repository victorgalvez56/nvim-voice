APP_NAME = NvimVoice
APP_BUNDLE = $(APP_NAME).app
SIGN_ID = Apple Development: Victor Galvez (7BVX533M64)
DMG_NAME = $(APP_NAME).dmg

.PHONY: dev watch build bundle run install dmg clean

# Dev: debug build + relaunch app bundle (~2-5s incremental)
dev:
	@swift build 2>&1 | tail -5
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@mkdir -p $(APP_BUNDLE)/Contents/Resources
	@cp NvimVoice/Resources/AppInfo.plist $(APP_BUNDLE)/Contents/Info.plist
	@test -f AppIcon.icns && cp AppIcon.icns $(APP_BUNDLE)/Contents/Resources/AppIcon.icns || true
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
	cp NvimVoice/Resources/AppInfo.plist $(APP_BUNDLE)/Contents/Info.plist
	test -f AppIcon.icns && cp AppIcon.icns $(APP_BUNDLE)/Contents/Resources/AppIcon.icns || true
	cp .build/release/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	codesign --force --sign "$(SIGN_ID)" --entitlements NvimVoice/Resources/NvimVoice.entitlements $(APP_BUNDLE)
	@echo "✅ $(APP_BUNDLE) ready"

run: bundle
	open $(APP_BUNDLE)

install: bundle
	cp -R $(APP_BUNDLE) /Applications/$(APP_BUNDLE)
	@echo "✅ Installed to /Applications/$(APP_BUNDLE)"

dmg: bundle
	@echo "📦 Creating $(DMG_NAME)..."
	@rm -rf /tmp/$(APP_NAME)-dmg
	@mkdir -p /tmp/$(APP_NAME)-dmg
	@cp -R $(APP_BUNDLE) /tmp/$(APP_NAME)-dmg/
	@ln -s /Applications /tmp/$(APP_NAME)-dmg/Applications
	@rm -f $(DMG_NAME)
	@hdiutil create -volname "$(APP_NAME)" -srcfolder /tmp/$(APP_NAME)-dmg -ov -format UDZO $(DMG_NAME)
	@rm -rf /tmp/$(APP_NAME)-dmg
	@echo "✅ $(DMG_NAME) ready"

clean:
	swift package clean
	rm -rf $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	rm -f $(DMG_NAME)
