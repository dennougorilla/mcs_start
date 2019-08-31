import 'dart:io';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;

import 'package:googleapis/compute/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx/Vm.dart';

final _credentials =
    ServiceAccountCredentials.fromJson(Platform.environment['MCSGCP_TOKEN']);

const _SCOPES = [
  'https://www.googleapis.com/auth/cloud-platform',
  'https://www.googleapis.com/auth/compute'
];

main() {
  Nyxx bot = NyxxVm(Platform.environment['MCSBOT_TOKEN']);
  bot.onMessageReceived.listen((MessageEvent e) {
    List<String> message = e.message.toString().split(' ');
    if (message[0] == '/status') {
      clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
        final client = commons.ApiRequester(
            http_client,
            "https://www.googleapis.com/",
            "compute/v1/projects/",
            'dart-api-client compute/v1');
        var instance = InstancesResourceApi(client);
        instance
            .get('minecraft-251315', 'asia-northeast1-b', 'mc-server')
            .then((ins) {
	  print(ins.status);
          switch (ins.status) {
            case 'RUNNING':
              bot.self
                  .setPresence(status: 'online', game: Presence.of(ins.status));
              break;
            default:
              bot.self
                  .setPresence(status: 'idle', game: Presence.of(ins.status));
          }
        });
      });
    }
    if (message[0] == '/start') {
      clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
        final client = commons.ApiRequester(
            http_client,
            "https://www.googleapis.com/",
            "compute/v1/projects/",
            'dart-api-client compute/v1');
        var instance = InstancesResourceApi(client);
        instance.start('minecraft-251315', 'asia-northeast1-b', 'mc-server');
      });
    }
    if (message[0] == '/stop') {
      clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
        final client = commons.ApiRequester(
            http_client,
            "https://www.googleapis.com/",
            "compute/v1/projects/",
            'dart-api-client compute/v1');
        var instance = InstancesResourceApi(client);
        instance.stop('minecraft-251315', 'asia-northeast1-b', 'mc-server');
      });
    }
  });
}
