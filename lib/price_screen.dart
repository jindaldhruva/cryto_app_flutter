import 'package:cryto_app_flutter/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io'
    show
        Platform; 
import 'dart:async';


final btcTextController = TextEditingController();
final ethTextController = TextEditingController();
final ltcTextController = TextEditingController();
Timer timer;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
        print(value);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        timer?.cancel();

        timer = Timer(const Duration(milliseconds: 3000), () {
          print('hi');
          getData();
        });
        setState(() {

          print(currenciesList[selectedIndex]);
          selectedCurrency = currenciesList[selectedIndex];
        });
          btcTextController.clear();
          ethTextController.clear();
          ltcTextController.clear();
      },
      children: pickerItems,
    );
  }

  // Widget getPicker() {
  //   if (Platform.isIOS) {
  //     return IOSPicker();
  //   } else if (Platform.isAndroid) {
  //     return androidDropdown();
  //   }
  // }

  String bitcoinValueInUSD = "0";
  String etheriumValueInUSD = "0";
  String liteCoinValueInUSD = "0";
  bool isWaiting = true, isDataFetched = false;
  Map<String, String> coinValues = {};
  void getData() async {
    isWaiting = true;
    try {
      final data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
        isDataFetched = true;
      });
    } catch (e) {
      print('Error in the getData method');
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 610),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //3: You'll need to use a Column Widget to contain the three CryptoCards.
              // isDataFetched
              //?
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CryptoCard(
                      cryptoCurrency: 'BTC',
                      //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
                      value: isWaiting ? '0' : coinValues['BTC'],
                      newValue: 0, //addding this works perfectly
                      selectedCurrency: selectedCurrency,
                      controller: btcTextController),
                  CryptoCard(
                      cryptoCurrency: 'ETH',
                      value: isWaiting ? '0' : coinValues['ETH'],
                      selectedCurrency: selectedCurrency,
                      controller: ethTextController),
                  CryptoCard(
                      cryptoCurrency: 'LTC',
                      value: isWaiting ? '0' : coinValues['LTC'],
                      selectedCurrency: selectedCurrency,
                      controller: ltcTextController),
                ],
              ),
              //: CircularProgressIndicator(),

              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                // child: Platform.isIOS ? CupertinoPicker() : androidDropdown(),
                child: iOSPicker(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CryptoCard extends StatefulWidget {
  CryptoCard(
      {this.amount,
      this.value,
      this.selectedCurrency,
      this.cryptoCurrency,
      this.isWaiting,
      this.newValue = 0,
      this.controller});

  String value;
  int amount = 1;
  final String selectedCurrency;
  final String cryptoCurrency;
  // Pass that api data here.
  int newValue;
  bool isWaiting = true;
  bool showNewValue = false;
  final TextEditingController controller;

  @override
  _CryptoCardState createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: '1',
                  ),
                  controller: widget.controller,
                  onSubmitted: (value) {
                    widget.showNewValue = true;
                    setState(
                      () {
                        print('THe value is $value');
                        widget.amount = int.parse(value);


                        widget.newValue =
                            int.parse(widget.value) * widget.amount;
                      },
                    );
                    print(widget.value);
                  },
                ),
              ),
              Text(
                widget.showNewValue
                    ? ' ${widget.cryptoCurrency} = ${widget.newValue} ${widget.selectedCurrency}'
                    : ' ${widget.cryptoCurrency} = ${widget.value} ${widget.selectedCurrency}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
