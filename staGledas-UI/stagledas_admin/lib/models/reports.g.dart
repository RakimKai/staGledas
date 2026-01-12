// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      brojKorisnika: json['brojKorisnika'] as int?,
      brojPremiumKorisnika: json['brojPremiumKorisnika'] as int?,
      brojFilmova: json['brojFilmova'] as int?,
      brojNovosti: json['brojNovosti'] as int?,
      brojFlagiranogSadrzaja: json['brojFlagiranogSadrzaja'] as int?,
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'brojKorisnika': instance.brojKorisnika,
      'brojPremiumKorisnika': instance.brojPremiumKorisnika,
      'brojFilmova': instance.brojFilmova,
      'brojNovosti': instance.brojNovosti,
      'brojFlagiranogSadrzaja': instance.brojFlagiranogSadrzaja,
    };

YearlyReport _$YearlyReportFromJson(Map<String, dynamic> json) => YearlyReport(
      godina: json['godina'] as int?,
      brojKorisnika: json['brojKorisnika'] as int?,
      brojPremiumKorisnika: json['brojPremiumKorisnika'] as int?,
      brojKreiranihRecenzija: json['brojKreiranihRecenzija'] as int?,
      ukupniPrihodi: (json['ukupniPrihodi'] as num?)?.toDouble(),
      brojAdministratora: json['brojAdministratora'] as int?,
    );

Map<String, dynamic> _$YearlyReportToJson(YearlyReport instance) =>
    <String, dynamic>{
      'godina': instance.godina,
      'brojKorisnika': instance.brojKorisnika,
      'brojPremiumKorisnika': instance.brojPremiumKorisnika,
      'brojKreiranihRecenzija': instance.brojKreiranihRecenzija,
      'ukupniPrihodi': instance.ukupniPrihodi,
      'brojAdministratora': instance.brojAdministratora,
    };

MonthlyUserStats _$MonthlyUserStatsFromJson(Map<String, dynamic> json) =>
    MonthlyUserStats(
      mjesec: json['mjesec'] as int?,
      nazivMjeseca: json['nazivMjeseca'] as String?,
      brojStandardnihKorisnika: json['brojStandardnihKorisnika'] as int?,
      brojPremiumKorisnika: json['brojPremiumKorisnika'] as int?,
    );

Map<String, dynamic> _$MonthlyUserStatsToJson(MonthlyUserStats instance) =>
    <String, dynamic>{
      'mjesec': instance.mjesec,
      'nazivMjeseca': instance.nazivMjeseca,
      'brojStandardnihKorisnika': instance.brojStandardnihKorisnika,
      'brojPremiumKorisnika': instance.brojPremiumKorisnika,
    };

AnalyticsReport _$AnalyticsReportFromJson(Map<String, dynamic> json) =>
    AnalyticsReport(
      godina: json['godina'] as int?,
      brojKorisnika: json['brojKorisnika'] as int?,
      brojPremiumKorisnika: json['brojPremiumKorisnika'] as int?,
      postotakPremiumKorisnika:
          (json['postotakPremiumKorisnika'] as num?)?.toDouble(),
      ukupniPrihodi: (json['ukupniPrihodi'] as num?)?.toDouble(),
      brojObrisanihRacuna: json['brojObrisanihRacuna'] as int?,
      rastUOdnosuNaProslodisnjuGodinu:
          (json['rastUOdnosuNaProslodisnjuGodinu'] as num?)?.toDouble(),
      brojKreiranihRecenzija: json['brojKreiranihRecenzija'] as int?,
      brojAdministratora: json['brojAdministratora'] as int?,
      mjesecnaStatistika: (json['mjesecnaStatistika'] as List<dynamic>?)
          ?.map((e) => MonthlyUserStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyticsReportToJson(AnalyticsReport instance) =>
    <String, dynamic>{
      'godina': instance.godina,
      'brojKorisnika': instance.brojKorisnika,
      'brojPremiumKorisnika': instance.brojPremiumKorisnika,
      'postotakPremiumKorisnika': instance.postotakPremiumKorisnika,
      'ukupniPrihodi': instance.ukupniPrihodi,
      'brojObrisanihRacuna': instance.brojObrisanihRacuna,
      'rastUOdnosuNaProslodisnjuGodinu': instance.rastUOdnosuNaProslodisnjuGodinu,
      'brojKreiranihRecenzija': instance.brojKreiranihRecenzija,
      'brojAdministratora': instance.brojAdministratora,
      'mjesecnaStatistika': instance.mjesecnaStatistika,
    };

UserTypeDistribution _$UserTypeDistributionFromJson(Map<String, dynamic> json) =>
    UserTypeDistribution(
      standardniKorisnici: json['standardniKorisnici'] as int?,
      premiumKorisnici: json['premiumKorisnici'] as int?,
      postotakPremium: (json['postotakPremium'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserTypeDistributionToJson(
        UserTypeDistribution instance) =>
    <String, dynamic>{
      'standardniKorisnici': instance.standardniKorisnici,
      'premiumKorisnici': instance.premiumKorisnici,
      'postotakPremium': instance.postotakPremium,
    };
