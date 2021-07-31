DARTANALYZER_FLAGS=--fatal-warnings

build: lib/*dart test/*dart deps
	dartanalyzer ${DARTANALYZER_FLAGS} lib/
	dartfmt -n --set-exit-if-changed lib/ test/
	#pub run test_coverage --print-test-output
	flutter test --coverage --coverage-path ./coverage/lcov.info

deps: pubspec.yaml
	pub get -v

reformatting:
	dartfmt -w lib/ test/

build-local: reformatting build
	genhtml -o coverage coverage/lcov.info
	lcov --list coverage/lcov.info
	lcov --summary coverage/lcov.info
	open coverage/index.html

pana:
	pana --no-warning

docs:
	rm -rf doc
	pub global run dartdoc --exclude 'dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:io,dart:isolate,dart:math,dart:typed_data,dart:ui,dart:html_common,dart:ffi,dart:html,dart:js,dart:js_util' --ignore 'ambiguous-doc-reference' --sdk-dir '${FLUTTER_ROOT}/bin/cache/dart-sdk'

publish:
	pub publish