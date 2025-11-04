import 'package:flutter/foundation.dart';

String apiBaseUrl() {
  // Altere a porta aqui se usar 3002 no backend
  const port = 3001;

  if (kIsWeb) {
    return 'http://localhost:$port';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      // Emulador Android acessa localhost da máquina via 10.0.2.2
      return 'http://10.0.2.2:$port';
    default:
      return 'http://localhost:$port';
  }
}