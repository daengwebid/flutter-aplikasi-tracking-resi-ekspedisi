import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  String noResi = '';
  String layanan = '';
  String name = '';
  String status = '';
  String tujuan = '';
  String date = '';
  String penerima = '';

  Detail(this.noResi, this.layanan, this.name, this.status, this.tujuan, this.date, this.penerima);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            '${noResi} - $layanan',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(),
                Text(
                  'Nama: $name',
                  style: TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
                Text(
                  'Status: $status',
                  style: TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
                Text(
                  'Tujuan: $tujuan',
                  style: TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
                Text(
                  'Tgl Terima: $date',
                  style: TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
                Text(
                  '$penerima',
                  style: TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}