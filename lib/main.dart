import 'dart:convert';

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
  var temp;
  var description;
  var currently;
  var humdity;
  var windspeed;

  Future getWeather() async {
    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?q=Cluj-Napoca&appid=75d39fd2d88201198549b6ce852968b1");
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.humdity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomLeft, colors: [
              ColorApp.darkblue,
              ColorApp.cyan[300],
            ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    Strings.currentlyInCluj,
                    style: roboto20White,
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "\u00B0" : "Loading",
                  style: roboto48White,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    description != null ? description.toString() : "Loading",
                    style: roboto20White,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text("Temperature"),
                  trailing: Text(temp != null ? temp.toString() + "\u00B0" : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Weather"),
                  trailing: Text(description != null ? description.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(WeatherIcons.humidity),
                  title: Text("Humidity"),
                  trailing: Text(humdity != null ? humdity.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("Wind Speed"),
                  trailing: Text(windspeed != null ? windspeed.toString() : "Loading"),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
