APP_NAME = NvimVoice
APP_BUNDLE = $(APP_NAME).app
SIGN_ID = Apple Development: Victor Galvez (7BVX533M64)
DMG_NAME = $(APP_NAME).dmg

.PHONY: dev watch build bundle run install dmg clean web-dev web-build

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
	@# Create read-write dmg, set Finder window properties, convert to compressed
	@hdiutil create -volname "$(APP_NAME)" -srcfolder /tmp/$(APP_NAME)-dmg -ov -format UDRW /tmp/$(APP_NAME)-rw.dmg
	@hdiutil attach /tmp/$(APP_NAME)-rw.dmg -mountpoint /tmp/$(APP_NAME)-vol
	@printf '%s\n' \
		'tell application "Finder"' \
		'  tell disk "$(APP_NAME)"' \
		'    open' \
		'    set current view of container window to icon view' \
		'    set toolbar visible of container window to false' \
		'    set statusbar visible of container window to false' \
		'    set bounds of container window to {100, 100, 640, 400}' \
		'    set theViewOptions to icon view options of container window' \
		'    set arrangement of theViewOptions to not arranged' \
		'    set icon size of theViewOptions to 80' \
		'    set position of item "$(APP_BUNDLE)" of container window to {120, 140}' \
		'    set position of item "Applications" of container window to {420, 140}' \
		'    close' \
		'    open' \
		'    update without registering applications' \
		'  end tell' \
		'end tell' > /tmp/$(APP_NAME)-dmg.scpt
	@osascript /tmp/$(APP_NAME)-dmg.scpt
	@sleep 1
	@hdiutil detach /tmp/$(APP_NAME)-vol
	@hdiutil convert /tmp/$(APP_NAME)-rw.dmg -format UDZO -o $(DMG_NAME)
	@rm -f /tmp/$(APP_NAME)-rw.dmg /tmp/$(APP_NAME)-dmg.scpt
	@rm -rf /tmp/$(APP_NAME)-dmg
	@echo "✅ $(DMG_NAME) ready"

clean:
	swift package clean
	rm -rf $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	rm -f $(DMG_NAME)

# Web (landing page)
web-dev:
	cd web && npm run dev

web-build:
	cd web && npm run build
