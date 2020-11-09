import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String country = "Iraq";

Future<dynamic> getData() async {
  String url =
      "https://api.quarantine.country/api/v1/spots/week?region=${country.toString()}";
  http.Response response = await http.get(url);
  return jsonDecode(response.body);
}

class _HomePageState extends State<HomePage> {
  var list;
  int total_cases;
  int deaths;
  int recovered;
  int critical;
  int tested;
  String lastTime;
  double death_ratio;
  double recovery_ratio;
  Timer time;
  NumberFormat numbertocomma = NumberFormat("###,###,###");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      testApi();
    });
  }

  @override
  void testApi() async {
    DateTime dateTime = DateTime.now();
/*
    var lastday = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
*/
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    list = await getData();
    print(formatter.format(dateTime));
    setState(() {
      total_cases = list["data"]["${formatter.format(dateTime)}"]["total_cases"];
      deaths = list["data"]["${formatter.format(dateTime)}"]["deaths"];
      lastTime = "${formatter.format(dateTime)}";
      recovered = list["data"]["${formatter.format(dateTime)}"]["recovered"];
      critical = list["data"]["${formatter.format(dateTime)}"]["critical"];
      tested = list["data"]["${formatter.format(dateTime)}"]["tested"];
      death_ratio = list["data"]["${formatter.format(dateTime)}"]["death_ratio"];
      recovery_ratio = list["data"]["${formatter.format(dateTime)}"]["recovery_ratio"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFD79A8),
      body: SafeArea(
        child: Container(

            color: Color(0xffFD79A8),
            child: Column(
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage('images/left.png'),
                      height: 100,
                      width: 100,
                    ),
                    Spacer(),
                    Image(
                      image: AssetImage('images/right.png'),
                      height: 120,
                      width: 120,
                    ),
                  ],
                ),
                Text(
                  "Covid-19 Overview \nfor $country ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),

                Container(
                  padding: EdgeInsets.all(12),
                  child:total_cases != null
                      ? Container(
                    height: 370,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child:  Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(20),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Total Case",
                                          style: TextStyle(
                                              color: Color(0xffFD63031),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Text(
                                          "$lastTime",
                                          style: TextStyle(
                                              color: Color(0xff434343),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            color: Color(0xff434343),
                                            icon: Icon(
                                                Icons.arrow_drop_down_sharp),
                                            onPressed: () {})
                                      ],
                                    ),
                                    Text(
                                      "${numbertocomma.format(total_cases)}",
                                      style: TextStyle(
                                          color: Color(0xffFD63031),
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color(0xffFF7675),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: overView(
                                          title: "deaths",
                                          counter:
                                              "${numbertocomma.format(deaths)}",
                                          textColor: Color(0xff636E72),
                                          backColor: Color(0xffB2BEC3))),
                                  Expanded(
                                      child: overView(
                                          title: "recovered",
                                          counter:
                                              "${numbertocomma.format(recovered)}",
                                          textColor: Color(0xff00B894),
                                          backColor: Color(0xff55EFC4))),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: overView(
                                          title: "death ratio",
                                          counter:
                                              "${death_ratio.toStringAsFixed(2)}",
                                          textColor: Color(0xff8E71A5),
                                          backColor: Color(0xffFB6A5CC))),
                                  Expanded(
                                      child: overView(
                                          title: "recovery ratio",
                                          counter:
                                              "${recovery_ratio.toStringAsFixed(2)}",
                                          textColor: Color(0xff1BA09D),
                                          backColor: Color(0xff81ECEC))),
                                ],
                              ),
                            ],
                          )


                  ): CircularProgressIndicator(),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      testApi();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      "Refresh",
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xffE84393),
                          fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],

            )
        ),
      ),
    );
  }

  Widget overView(
      {String title, String counter, Color textColor, Color backColor}) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "$counter",
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: backColor,
      ),
    );
  }
}
