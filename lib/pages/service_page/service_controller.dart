import 'package:tamirci/core/models/m_service.dart';

class ServiceController {
  MService Function(MService service)? receiveService;

  void dispose() {
    receiveService = null;
  }
}
