import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './detail.dart';

class ResiSilincah extends StatefulWidget {
  @override
  _ResiSilincahState createState() => _ResiSilincahState();
}

class _ResiSilincahState extends State<ResiSilincah> {
  String noResi = '';
  String layanan = '';
  String name = '';
  String status = '';
  String tujuan = '';
  String date = '';
  String penerima = '';

  final TextEditingController _resiController = TextEditingController();

  bool loading = false;
  bool showDetail = false;
  bool isNotFound = false;
  FocusNode _focusNode;

  void cekResi() async {
    setState(() {
      showDetail = false;
      isNotFound = false;
      loading = true;
    });

    Map<String, String> requestHeaders = {
      'Accept': 'application/json, text/javascript, */*; q=0.01',
      'Accept-Encoding': 'gzip, deflate',
      'Accept-Language': 'en-US,en;q=0.9',
      'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Host': 'sicepat.com',
      'Origin': 'http://sicepat.com',
      'Referer': 'http://sicepat.com',
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36',
      'Cookie':
          '__cfduid=d4a82874e43363ef776bd20169c2e37ca1568383926; ci_session=nphsvktt6jl68lu74er1osttbfc4ct9d',
      'X-Requested-With': 'XMLHttpRequest'
    };

    Map<String, String> resi = {'awb[]': _resiController.text};

    final response = await http.post('http://sicepat.com/checkAwb/doSearch',
        body: resi, headers: requestHeaders);
    final content = json.decode(response.body)['html'];
    final withoutHtml = removeHeading(content);

    setState(() {
      loading = false;
      if (withoutHtml.length > 1) {
        noResi = explodeItem(withoutHtml[1], '<div class="visible-xs">', 0);
        layanan = explodeItem(withoutHtml[1], '<div class="visible-xs">', 1);
        name = explodeItem(withoutHtml[4], '<td class="hidden-xs">', 1);
        status = explodeItem(withoutHtml[7], '<td>', 1);
        tujuan = explodeItem(withoutHtml[3], '<div class="visible-xs">', 0);
        date = explodeItem(withoutHtml[5], '<div class="visible-xs">', 0);
        penerima = explodeItem(withoutHtml[5], '<div class="visible-xs">', 1);
        showDetail = true;
      } else {
        isNotFound = true;
      }

      FocusScope.of(context).nextFocus();
      _resiController.clear();
    });
    return;
  }

  List removeHeading(String htmlText) {
    final removeHeading = htmlText.replaceAll(
        '<div class=\"awb-detail-title text-center\">       <div class=\"container\">           Status Pengiriman Anda       </div>   </div>   <div class=\"awb-detail-sub-title text-center\">       <div class=\"container\">           Terimakasih telah menggunakan pengiriman SiCepat. Silahkan cek daftar pengiriman Anda       </div>   </div><span class=\"awb-click-info\">Silahkan klik salah satu baris untuk melihat detail pengiriman.</span>   <div class=\"table-responsive\"><table id=\"awb-list\" class=\"table table-striped  nowrap ws-table\"\n                 cellspacing=0 width=\"100%\">  <thead><tr> <th  id=\"seq\" class=\"hidden-xs\">No</th> <th  id=\"awb_number\" class=\"\">No RESI</th> <th  id=\"service\" class=\"hidden-xs\">Layanan</th> <th  id=\"destination\" class=\"\">Tujuan</th> <th  id=\"receipt_name\" class=\"hidden-xs\">Penerima</th> <th  id=\"receipt_date\" class=\"\">Tgl Diterima</th> <th  id=\"receipt_paket\" class=\"hidden-xs\">Penerima Paket</th> <th  id=\"status\" class=\"\">STATUS</th></tr>  </thead><tbody><tr class=\"res-item\"> ',
        '');
    final splitTd = removeHeading.split('</td>');
    return splitTd.toList();
  }

  String explodeItem(String str, String remove, int index) {
    final result = str.split(remove).toList();

    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return result[index].replaceAll(exp, '');
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _resiController.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.art_track), title: Text('Daengweb Resi')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _resiController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan Resi',
                      labelText: 'Nomor Resi'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text("Cari"),
                  highlightElevation: 2,
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: cekResi,
                ),
              ),
              Divider(),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : showDetail
                      ? Detail(
                          noResi, layanan, name, status, tujuan, date, penerima)
                      : isNotFound
                          ? Card(
                              elevation: 4,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Nomor Resi Tidak Ditemukan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            )
                          : Center()
            ],
          ),
        ),
      ),
    );
  }
}
