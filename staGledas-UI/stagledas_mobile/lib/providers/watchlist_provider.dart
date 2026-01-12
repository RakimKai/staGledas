import 'package:stagledas_mobile/models/watchlist.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';

class WatchlistProvider extends BaseProvider<Watchlist> {
  WatchlistProvider() : super("Watchlist");

  @override
  Watchlist fromJson(data) {
    return Watchlist.fromJson(data);
  }
}
