import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/strings.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_icons/weather_icons.dart';

void main() => runApp(MaterialApp(
      title: "Weather App",
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  double temp;
  var description;
  var currently;
  var humdity;
  var windspeed;
  var oras = 'Covasna';
  TextEditingController searchController = TextEditingController();

  Future getWeather(String oras) async {
    http.Response response =
        await http.get("http://api.openweathermap.org/data/2.5/weather?q=$oras&appid=75d39fd2d88201198549b6ce852968b1");
    var results = jsonDecode(response.body);
    setState(() {
      this.oras = oras;
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.humdity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather(oras);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomLeft, colors: [
          ColorApp.deeppurple[800],
          ColorApp.deeppurple[600],
          ColorApp.purpleaccent,
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      color: Colors.white.withOpacity(0.07),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextField(
                                decoration: InputDecoration(border: InputBorder.none),
                                controller: searchController,
                                style: roboto18White,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: ColorApp.white,
                              ),
                              onPressed: () => getWeather(searchController.text))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                Strings.currentlyIn + oras,
                style: roboto20White,
              ),
            ),
            Text(
              temp != null ? (temp - 273.15).toStringAsFixed(2) + "\u00B0C" : "Loading",
              style: roboto48White,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 24.0),
              child: Text(
                description != null ? description.toString() : "Loading",
                style: roboto20White,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                color: ColorApp.white.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.thermometerHalf,
                          color: ColorApp.white,
                        ),
                        title: Text(
                          "Temperature",
                          style: roboto16White,
                        ),
                        trailing: Text(
                          temp != null ? (temp - 273.15).toStringAsFixed(2) + "\u00B0C" : "Loading",
                          style: roboto16White,
                        ),
                      ),
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.cloud,
                          color: ColorApp.white,
                        ),
                        title: Text(
                          "Weather",
                          style: roboto16White,
                        ),
                        trailing: Text(
                          description != null ? description.toString() : "Loading",
                          style: roboto16White,
                        ),
                      ),
                      ListTile(
                        leading: FaIcon(
                          WeatherIcons.humidity,
                          color: ColorApp.white,
                        ),
                        title: Text(
                          "Humidity",
                          style: roboto16White,
                        ),
                        trailing: Text(
                          humdity != null ? humdity.toString() : "Loading",
                          style: roboto16White,
                        ),
                      ),
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.wind,
                          color: ColorApp.white,
                        ),
                        title: Text(
                          "Wind Speed",
                          style: roboto16White,
                        ),
                        trailing: Text(
                          windspeed != null ? windspeed.toString() : "Loading",
                          style: roboto16White,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
