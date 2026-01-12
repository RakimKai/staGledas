import 'package:stagledas_mobile/models/pratitelji.dart';
import 'package:stagledas_mobile/providers/base_provider.dart';
import 'package:stagledas_mobile/utils/auth_util.dart';

class PratiteljiProvider extends BaseProvider<Pratitelji> {
  PratiteljiProvider() : super("Pratitelji");

  @override
  Pratitelji fromJson(data) {
    return Pratitelji.fromJson(data);
  }

  Future<Pratitelji> follow(int userIdToFollow) async {
    return await insert({
      'KorisnikId': userIdToFollow,
    });
  }

  Future<void> unfollow(int followRecordId) async {
    await delete(followRecordId);
  }

  Future<Pratitelji?> isFollowing(int userIdToCheck) async {
    var result = await get(filter: {
      'KorisnikId': userIdToCheck,
      'PratiteljId': Authorization.id,
    });

    if (result.result.isNotEmpty) {
      return result.result.first;
    }
    return null;
  }

  Future<bool> areMutualFollowers(int userId) async {
    var iFollow = await get(filter: {
      'KorisnikId': userId,
      'PratiteljId': Authorization.id,
    });

    var theyFollowMe = await get(filter: {
      'KorisnikId': Authorization.id,
      'PratiteljId': userId,
    });

    return iFollow.result.isNotEmpty && theyFollowMe.result.isNotEmpty;
  }

  Future<List<Pratitelji>> getFollowers(int userId) async {
    var result = await get(filter: {
      'KorisnikId': userId,
      'IsPratiteljIncluded': true,
    });
    return result.result;
  }

  Future<List<Pratitelji>> getFollowing(int userId) async {
    var result = await get(filter: {
      'PratiteljId': userId,
      'IsKorisnikIncluded': true,
    });
    return result.result;
  }
}
