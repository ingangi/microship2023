// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      userName: json['userName'] as String?,
      passWord: json['passWord'] as String?,
      domain: json['domain'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userName', instance.userName);
  writeNotNull('passWord', instance.passWord);
  writeNotNull('domain', instance.domain);
  writeNotNull('desc', instance.desc);
  return val;
}

Config _$ConfigFromJson(Map<String, dynamic> json) => Config()
  ..accounts = (json['accounts'] as List<dynamic>?)
      ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
      .toList()
  ..registerTimer = json['registerTimer'] as int
  ..transport = $enumDecode(_$TransportEnumMap, json['transport']);

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'accounts': instance.accounts,
      'registerTimer': instance.registerTimer,
      'transport': _$TransportEnumMap[instance.transport],
    };

const _$TransportEnumMap = {
  Transport.udp: 'udp',
  Transport.tcp: 'tcp',
  Transport.tls: 'tls',
};
