import 'config.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

typedef OnGlobalReadyCallback = void Function();

// var global = Global();
class Global {
  bool ready = false;
  final Map<String, OnGlobalReadyCallback> _readyCallback =
      <String, OnGlobalReadyCallback>{};
  Config? config;
  // SipHelper sip = SipHelper();
  static const String configPath = "assets/config.json";

  static final Global _singleton = Global._internal();

  factory Global() {
    return _singleton;
  }

  void registerCallback(String key, OnGlobalReadyCallback callback) {
    print("Global::registerCallback $key");
    _readyCallback[key] = callback;
    if (ready) {
      print("Global::registerCallback $key, already ready, call it now!");
      callback();
    }
  }

  void unregisterCallback(String key) {
    print("Global::unregisterCallback $key");
    _readyCallback.remove(key);
  }

  void notifyUIUpdate() {
    _readyCallback.forEach((key, value) {
      print("notifyUIUpdate, _readyCallback $key");
      value();
    });
  }

  Account? currentAccount() {
    return config?.accounts?[0];
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map =
        jsonDecode(await rootBundle.loadString(configPath));
    config = Config.fromJson(map);
    print("loading config from file: ${config.toString()}");

    // load custimized config
    final String? customConfig = prefs.getString('config');
    if (customConfig != null) {
      config!.merge(Config.fromJson(jsonDecode(customConfig)));
    }
    print("merge config from SharedPreferences: ${config.toString()}");
    // sip.register(
    //     wsDomain: currentAccount()!.domain!,
    //     userName: currentAccount()!.userName!,
    //     pswd: currentAccount()!.passWord!,
    //     registerTimer: config!.registerTimer);
  }

  Future<void> saveToPreference() async {
    final prefs = await SharedPreferences.getInstance();
    // config?.registerTimer = 99; // test
    print("writing config from file. ${config.toString()}");
    await prefs.setString('config', config.toString());
    // sip.register(
    //     wsDomain: currentAccount()!.domain!,
    //     userName: currentAccount()!.userName!,
    //     pswd: currentAccount()!.passWord!,
    //     registerTimer: config!.registerTimer);
  }

  Global._internal() {
    print("Global created!");
    // sip.init();
    loadConfig().then((value) {
      ready = true;
      notifyUIUpdate();
    });
  }
}
