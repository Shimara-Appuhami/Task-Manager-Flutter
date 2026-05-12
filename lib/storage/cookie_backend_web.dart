// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

String? readCookieString() => html.document.cookie;

void writeCookieString(String value) {
  html.document.cookie = value;
}
