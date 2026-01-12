import 'package:json_annotation/json_annotation.dart';

part 'reports.g.dart';

@JsonSerializable()
class DashboardStats {
  int? brojKorisnika;
  int? brojPremiumKorisnika;
  int? brojFilmova;
  int? brojNovosti;
  int? brojFlagiranogSadrzaja;

  DashboardStats({
    this.brojKorisnika,
    this.brojPremiumKorisnika,
    this.brojFilmova,
    this.brojNovosti,
    this.brojFlagiranogSadrzaja,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}

@JsonSerializable()
class YearlyReport {
  int? godina;
  int? brojKorisnika;
  int? brojPremiumKorisnika;
  int? brojKreiranihRecenzija;
  double? ukupniPrihodi;
  int? brojAdministratora;

  YearlyReport({
    this.godina,
    this.brojKorisnika,
    this.brojPremiumKorisnika,
    this.brojKreiranihRecenzija,
    this.ukupniPrihodi,
    this.brojAdministratora,
  });

  factory YearlyReport.fromJson(Map<String, dynamic> json) => _$YearlyReportFromJson(json);
  Map<String, dynamic> toJson() => _$YearlyReportToJson(this);
}

@JsonSerializable()
class MonthlyUserStats {
  int? mjesec;
  String? nazivMjeseca;
  int? brojStandardnihKorisnika;
  int? brojPremiumKorisnika;

  MonthlyUserStats({
    this.mjesec,
    this.nazivMjeseca,
    this.brojStandardnihKorisnika,
    this.brojPremiumKorisnika,
  });

  factory MonthlyUserStats.fromJson(Map<String, dynamic> json) => _$MonthlyUserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyUserStatsToJson(this);
}

@JsonSerializable()
class AnalyticsReport {
  int? godina;
  int? brojKorisnika;
  int? brojPremiumKorisnika;
  double? postotakPremiumKorisnika;
  double? ukupniPrihodi;
  int? brojObrisanihRacuna;
  double? rastUOdnosuNaProslodisnjuGodinu;
  int? brojKreiranihRecenzija;
  int? brojAdministratora;
  List<MonthlyUserStats>? mjesecnaStatistika;

  AnalyticsReport({
    this.godina,
    this.brojKorisnika,
    this.brojPremiumKorisnika,
    this.postotakPremiumKorisnika,
    this.ukupniPrihodi,
    this.brojObrisanihRacuna,
    this.rastUOdnosuNaProslodisnjuGodinu,
    this.brojKreiranihRecenzija,
    this.brojAdministratora,
    this.mjesecnaStatistika,
  });

  factory AnalyticsReport.fromJson(Map<String, dynamic> json) => _$AnalyticsReportFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsReportToJson(this);
}

@JsonSerializable()
class UserTypeDistribution {
  int? standardniKorisnici;
  int? premiumKorisnici;
  double? postotakPremium;

  UserTypeDistribution({
    this.standardniKorisnici,
    this.premiumKorisnici,
    this.postotakPremium,
  });

  factory UserTypeDistribution.fromJson(Map<String, dynamic> json) => _$UserTypeDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$UserTypeDistributionToJson(this);
}
