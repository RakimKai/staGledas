import 'package:stagledas_mobile/models/zalba.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class ZalbaProvider extends BaseProvider<Zalba> {
  ZalbaProvider() : super("Zalbe");

  @override
  Zalba fromJson(data) {
    return Zalba.fromJson(data);
  }
}
