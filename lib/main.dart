import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hive_kullanimi/models/ogrenci.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("uygulama");

  /* Hive verilern şlifrellenerek saklanması */
  //  Enrypted
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var containsEnryptionKey = await secureStorage.containsKey(key: "key");
  if (!containsEnryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(key: "key", value: base64UrlEncode(key));
  }

  var encryptionKey =
      base64Url.decode(await secureStorage.read(key: "key") ?? "");
  print("encryption key: ${encryptionKey}");

  var sifreliKutu = await Hive.openBox("ozel",
      encryptionCipher: HiveAesCipher(encryptionKey));
  await sifreliKutu.put("secret", "Hive is cool..");
  await sifreliKutu.put("sifre", "saklıŞifre");
  print("secret: " + sifreliKutu.get("secret"));
  print("sifre: " + sifreliKutu.get("sifre"));

/* hive box kullanımı */
  // await Hive.openBox<String>("test");
  Hive.registerAdapter(OgrenciAdapter());
  Hive.registerAdapter(GozRengiAdapter());
  await Hive.openBox<Ogrenci>("Ogrenciler");

/* Lazybox kullanımı */
  await Hive.openLazyBox<int>("sayilar");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Hive ve Encryption'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _incrementCounter() async {
    // Hive.close();
    await Hive.openBox("test");
    var box = Hive.box("test");
    await box.clear();
    box.add("Ozi"); // index 0 key 0 value Ozi
    box.add("Mozi"); // index 1 key 1 value Mozi
    box.add(true); // index 2 key 2 value true
    box.add(123); // index 3 key 3 value 123

    // box.addAll(["liste1", "liste2", false, "liste4", 123123]);

    // await box.putAll({"araba": "Mercedes", "yil": 2022});

    await box.put("tc", "27819238");
    await box.put("tema", "dark");
    /* 
    box.values.forEach((element) {
      print(element.toString());
    });
     */

    print(box.toMap().toString());
    print(box.get("tema")); //key ile erişim
    print(box.getAt(0)); //index ile erişim
    print(box.length.toString());
    await box.delete("tc");
    print("tc: ${box.get("tc")}");
    box.putAt(0, "OZZİ");
    print(box.toMap().toString());
  }

  Future<void> _customData() async {
    var oguzhan = Ogrenci(id: 4, isim: "Oğuzhan", GozRengi: GozRengi.SIYAH);
    var hasan = Ogrenci(id: 10, isim: "Hasan", GozRengi: GozRengi.MAVI);

    var box = Hive.box<Ogrenci>("Ogrenciler");

    box.clear();

    box.add(oguzhan);
    box.add(hasan);

    box.put("oguzhan", oguzhan);
    box.put("hasan", hasan);

    print(box.toMap().toString());
  }

  Future<void> _lazyAndEncrytedBox() async {
    var lazyBox = Hive.lazyBox<int>("sayilar");
    for (var i = 0; i < 500; i++) {
      lazyBox.add(i * 50);
    }

    for (var i = 0; i < 50; i++) {
      print(await lazyBox.get(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hive Kullanım testi',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _lazyAndEncrytedBox,
        tooltip: 'Bana Bas',
        child: const Icon(Icons.add),
      ),
    );
  }
}
