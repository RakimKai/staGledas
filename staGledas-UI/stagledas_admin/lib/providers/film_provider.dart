import 'package:stagledas_admin/models/film.dart';
import 'package:stagledas_admin/providers/base_provider.dart';

class FilmProvider extends BaseProvider<Film> {
  FilmProvider() : super("Filmovi");

  @override
  Film fromJson(data) {
    return Film.fromJson(data);
  }
}
