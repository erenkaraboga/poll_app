import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:poll_app/CreatePollPage.dart';

import 'home.dart';

void main() {

  runApp(GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anket Uygulaması',
      theme: ThemeData(
        fontFamily: "Mali",
        primarySwatch: Colors.blue,
      ),
      home: CreatePollPage(),
    );
  }
}

class AnketUygulamasi extends StatefulWidget {
  @override
  _AnketUygulamasiState createState() => _AnketUygulamasiState();
}

class _AnketUygulamasiState extends State<AnketUygulamasi> {
  List<String> soruTipleri = ['Açık Uçlu', 'Çoktan Seçmeli', 'Puanlama']; // Soru tipleri listesi
  List<String> secilenSorular = []; // Seçilen soruların listesi
  int _siraNumarasi = 0; //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anket Uygulaması'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sorular',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: soruTipleri.length,
                    itemBuilder: (context, index) {
                      return Draggable<String>(
                        data: soruTipleri[index],
                        child: _buildSoruTuru(soruTipleri[index]),
                        feedback: _buildSoruTuru(soruTipleri[index], dragging: true),
                        childWhenDragging: Container(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seçilen Sorular',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Seçilen soruları listelemek için ReorderableListView kullanılıyor
                Expanded(
                  child: DragTarget<String>(
                    onAccept: (String data) {
                      setState(() {
                        secilenSorular.add(data);
                      });
                    },
                    builder: (context, accepted, rejected) {
                      return ReorderableListView(
                        children: secilenSorular
                            .map((soru) => ListTile(
                          key: Key('${soru}_${_siraNumarasi++}'),
                          title: Text(soru),
                        ))
                            .toList(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = secilenSorular.removeAt(oldIndex);
                            secilenSorular.insert(newIndex, item);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoruTuru(String tur, {bool dragging = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      color: dragging ? Colors.grey.withOpacity(0.5) : Colors.blue,
      child: Text(
        tur,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}