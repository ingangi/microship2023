import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(includeIfNull: false)
class Account {
  final String? userName, passWord, domain, desc;
  Account({this.userName, this.passWord, this.domain, this.desc});
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
  bool compare(Account other) {
    return userName == other.userName &&
        passWord == other.passWord &&
        domain == other.domain &&
        desc == other.desc;
  }
}

enum Transport {
  udp,
  tcp,
  tls,
}

// generate by: (microship2023/lib) flutter pub run build_runner build
@JsonSerializable()
class Config {
  List<Account>? accounts;
  int registerTimer = 30;
  Transport transport = Transport.tcp;
  bool isAccountsEqule(List<Account>? other) {
    if (other == null || accounts == null) {
      return false;
    }

    if (other.length != accounts!.length) {
      return false;
    }

    for (int i = 0; i < other.length; i++) {
      if (!other[i].compare(accounts![i])) {
        return false;
      }
    }
    return true;
  }

  Config();
  // if things were different, return true.
  bool merge(Config other) {
    bool diff = false;
    if (other.accounts != null &&
        other.accounts!.isNotEmpty &&
        !isAccountsEqule(other.accounts)) {
      accounts = other.accounts;
      diff = true;
    }
    if (other.registerTimer > 0 && registerTimer != other.registerTimer) {
      registerTimer = other.registerTimer;
      diff = true;
    }
    if (transport != other.transport) {
      transport = other.transport;
      diff = true;
    }
    return diff;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
