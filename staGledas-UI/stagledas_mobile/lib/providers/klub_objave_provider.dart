import 'package:stagledas_mobile/models/klub_objave.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class KlubObjaveProvider extends BaseProvider<KlubObjave> {
  KlubObjaveProvider() : super("KlubObjave");

  @override
  KlubObjave fromJson(data) {
    return KlubObjave.fromJson(data);
  }
}
