import 'package:flutter/foundation.dart' show kIsWeb;

const bool isTestMode = true;

final baseURL = isTestMode
    ? kIsWeb
    ? 'http://localhost:8080'
    : 'http://10.0.2.2:8080'
    : kIsWeb
    ? 'https://qruto-budget-app-bd7e344cca5d.herokuapp.com'
    : 'https://qruto-budget-app-bd7e344cca5d.herokuapp.com';
