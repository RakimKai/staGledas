import 'package:stagledas_admin/models/recenzija.dart';
import 'package:stagledas_admin/providers/base_provider.dart';

class RecenzijaProvider extends BaseProvider<Recenzija> {
  RecenzijaProvider() : super("Recenzije");

  @override
  Recenzija fromJson(data) {
    return Recenzija.fromJson(data);
  }
}
