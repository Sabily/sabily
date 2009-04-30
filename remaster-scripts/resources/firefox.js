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

// Prevent EULA dialog to popup on first run
pref("browser.EULA.override", true);

// identify ubuntu @ yahoo searchplugin
pref("browser.search.param.yahoo-fr", "ubuntu");

// Use Dansguardian:
lockPref("network.proxy.http_port", 8080);
lockPref("network.proxy.share_proxy_settings", true);
lockPref("network.proxy.ssl", "127.0.0.1");
lockPref("network.proxy.type", 1);
lockPref("network.proxy.gopher_port", 8080);
lockPref("network.proxy.socks_port", 8080);
lockPref("network.proxy.http", "127.0.0.1");
lockPref("network.proxy.gopher", "127.0.0.1");
lockPref("network.proxy.no_proxies_on", "localhost, 127.0.0.1");
lockPref("network.proxy.ssl_port", 8080);
lockPref("network.proxy.ftp", "127.0.0.1");
lockPref("network.proxy.socks", "127.0.0.1");
lockPref("network.proxy.ftp_port", 8080);

