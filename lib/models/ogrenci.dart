import 'package:hive_flutter/adapters.dart';
part 'ogrenci.g.dart';

@HiveType(typeId: 1)
class Ogrenci {
  @HiveField(0, defaultValue: 555)
  final int id;
  @HiveField(1)
  final String isim;
  @HiveField(2)
  final Enum GozRengi;

  Ogrenci({required this.id, required this.isim, required this.GozRengi});

  @override
  String toString() {
    // TODO: implement toString
    return "id:$id, isim:$isim, goz rengi: ${GozRengi.name} ";
  }
}

@HiveType(typeId: 2)
enum GozRengi {
  @HiveField(0, defaultValue: true)
  SIYAH,
  @HiveField(1)
  MAVI,
  @HiveField(2)
  YESIL
}
