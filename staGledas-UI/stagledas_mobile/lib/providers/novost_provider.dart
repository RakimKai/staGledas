import 'package:stagledas_mobile/models/novost.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class NovostProvider extends BaseProvider<Novost> {
  NovostProvider() : super("Novosti");

  @override
  Novost fromJson(data) {
    return Novost.fromJson(data);
  }
}
