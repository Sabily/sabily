// This is the Debian specific preferences file for Mozilla Firefox
// You can make any change in here, it is the purpose of this file.
// You can, with this file and all files present in the
// /etc/firefox/pref directory, override any preference that is
// present in /usr/lib/firefox/defaults/pref directory.
// While your changes will be kept on upgrade if you modify files in
// /etc/firefox/pref, please note that they won't be kept if you
// do them in /usr/lib/firefox/defaults/pref.

pref("extensions.update.enabled", true);

// Use LANG environment variable to choose locale
pref("intl.locale.matchOS", true);

// Disable default browser checking.
pref("browser.shell.checkDefaultBrowser", false);

// Disable safebrowsing.
pref("browser.safebrowsing.enabled", true);

// Use Dansguardian:
pref("app.update.enabled", false);
pref("app.update.auto", false);
pref("network.proxy.http_port", 8080);
pref("network.proxy.share_proxy_settings", true);
pref("network.proxy.ssl", "127.0.0.1");
pref("network.proxy.type", 1);
pref("network.proxy.gopher_port", 8080);
pref("network.proxy.socks_port", 8080);
pref("network.proxy.http", "127.0.0.1");
pref("network.proxy.gopher", "127.0.0.1");
pref("network.proxy.no_proxies_on", "localhost, 127.0.0.1");
pref("network.proxy.ssl_port", 8080);
pref("network.proxy.ftp", "127.0.0.1");
pref("network.proxy.socks", "127.0.0.1");
pref("network.proxy.ftp_port", 8080);

