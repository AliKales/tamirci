import 'package:flutter/foundation.dart';
import 'package:tamirci/core/models/m_service.dart';

class ServiceController {
  MService Function(MService service)? receiveService;
  VoidCallback? updateTextFields;

  void dispose() {
    receiveService = null;
    updateTextFields = null;
  }
}
