import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//Library para converter os dados para json
import 'dart:convert';

const request = "https://www.mercadobitcoin.net/api/BTC/ticker";
const requestTwo = "https://www.mercadobitcoin.net/api/BTC/ticker";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.black,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//Criando controladores

  WebViewController _controller;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  //Instanciando moedas
  double dolar;
  double euro;
  double bitcoin;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();

      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();

      return;
    }

    double dolar = double.parse(text);
    this.dolar;

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (this.dolar * dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();

      return;
    }

    double euro = double.parse(text);
    this.euro;

    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    print(this.euro);
  }

  void _bitcoinChanged(String text) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text("Carregando Dados!"),
                );
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando Dados!"),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar Dados :(",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  String bitcoins = snapshot.data["ticker"]["last"];
                  String bitcoinsMax = snapshot.data["ticker"]["high"];
                  String bitcoinsLow = snapshot.data["ticker"]["low"];

                  double btcc = double.parse(bitcoins);
                  double btcLow = double.parse(bitcoinsLow);
                  double btcHigh = double.parse(bitcoinsLow);
                  String bitcoinLastPrice = btcc.toStringAsFixed(2);
                  String bitcoinLowPrice = btcLow.toStringAsFixed(2);
                  String bitcoinHighPrice = btcHigh.toStringAsFixed(2);

                  print(bitcoins);

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildStackBitcoin(),
                          Divider(),
                          _buildCard(bitcoinLastPrice, bitcoinLowPrice,
                              bitcoinHighPrice),
                          Divider(),
                          _buildStackEtherum(),
                          Center(
                            child: Text("Preço do Bitcoin: R\$" +
                                btcc.toStringAsFixed(2)),
                          ),
                        ],
                      ));
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController moedaController, Function f) {
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.blueAccent),
      border: OutlineInputBorder(),
      prefixText: prefix,

//        hintText: "Insira o valor que você deseja converter"
    ),
    controller: moedaController,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

Widget _buildCard(String lastPrice, String lowPrice, String highPrice) =>
    SizedBox(
      height: 100,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('Último Preço:R\$$lastPrice',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              subtitle:
                  Text('Menor valor: R\$$lowPrice\nMaior valor: R\$$highPrice'),
              leading: Icon(
                Icons.attach_money,
                color: Colors.blue[500],
              ),
            ),
          ],
        ),
      ),
    );

Widget _buildStackBitcoin() => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.amber,
            backgroundImage: AssetImage('assets/images/bitcoin.png'),
            radius: 100,
          ),
        )
      ],
    );
Widget _buildStackEtherum() => Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        Center(
          child: Container(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: const BorderRadius.all(const Radius.circular(8)),
              ),
              margin: const EdgeInsets.all(4),
              child: Image.asset('assets/images/ethereum.png'),
            ),
          ),
        )
      ],
    );
