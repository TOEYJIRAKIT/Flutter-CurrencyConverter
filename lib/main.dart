import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ExchangeRate.dart';
import 'moneybox.dart';

void main() {
  runApp(MyApp());
}

//สร้าง Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomePage(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExchangeRate? _dataFromAPI;
  @override
  void initState() {
    super.initState();
    getExchangeRate();
  }

  Future <ExchangeRate?> getExchangeRate() async {
    var url = Uri.parse('https://api.exchangerate-api.com/v4/latest/THB');
    var response = await http.get(url);
    _dataFromAPI = exchangeRateFromJson(response.body);
    return _dataFromAPI;
  }

  //แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แลกเปลี่ยนสกุลเงิน",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
          future: getExchangeRate(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

            if(snapshot.connectionState == ConnectionState.done){
              var result = snapshot.data;
              double amount = 100;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MoneyBox("สกุลเงิน (THB)", amount, Colors.blue, 150),
                    SizedBox(height: 5,),
                    MoneyBox("สกุลเงิน (EUR)", amount*result.rates["EUR"], Colors.green, 120),
                    SizedBox(height: 5,),
                    MoneyBox("สกุลเงิน (USD)", amount*result.rates["USD"], Colors.red, 120),
                    SizedBox(height: 5,),
                    MoneyBox("สกุลเงิน (JPY)", amount*result.rates["JPY"], Colors.pink, 120),
                    SizedBox(height: 5,),
                    MoneyBox("สกุลเงิน (GBP)", amount*result.rates["GBP"], Colors.orange, 120)
                  ],
                ),
              );
            }
            return LinearProgressIndicator();
          },)
        );
  }
}
