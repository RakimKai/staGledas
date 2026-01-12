import 'package:stagledas_mobile/models/klub_komentari.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class KlubKomentariProvider extends BaseProvider<KlubKomentari> {
  KlubKomentariProvider() : super("KlubKomentari");

  @override
  KlubKomentari fromJson(data) {
    return KlubKomentari.fromJson(data);
  }
}
