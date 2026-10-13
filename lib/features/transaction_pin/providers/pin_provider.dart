import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_response.dart';
import '../data/services/pin_service.dart';

part 'pin_provider.g.dart';

@riverpod
class PinNotifier extends _$PinNotifier {
  final _service = PinService();

  @override
  void build() {}

  Future<ApiResponse<dynamic>> createPin({required String pin}) {
    return _service.createPin(pin: pin);
  }
}
