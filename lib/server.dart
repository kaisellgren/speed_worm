library speed_worm_server;

import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';

class Server {
  Server() {
    var staticFiles = new VirtualDirectory('web')
      ..allowDirectoryListing = true
      ..followLinks = true
      ..jailRoot = false;

    HttpServer.bind('0.0.0.0', 80).then((server) {
      print('Server running.');
      server.listen(staticFiles.serveRequest);
    });
  }
}
