import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/components/hourly_forecast_item.dart';
import 'package:weather_app/components/additional_info_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/components/secrets.dart';




class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

double temp = 0;


class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String,dynamic>> weather;

    Future<Map<String,dynamic>> getCurrentWeather() async {
    try{
      String  cityName = 'Hyderabad';
      final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'
        ),
      );
      final data = jsonDecode(res.body);

      if(data['cod']!='200'){
        throw "An unexpected error occured";
      }
      return data;
    }catch(e){
    throw e.toString();
  }
  }

  
  @override
  void initState() {
    super.initState();
     weather = getCurrentWeather();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App' ,
        style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions:  [
          IconButton(
            onPressed: (){
              setState(() {
                weather = getCurrentWeather();
              });
            }, 
            icon: const Icon(Icons.refresh),
            )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = (currentWeatherData['main']['temp'] -273.15).toStringAsFixed(2);
          final currentSky = currentWeatherData['weather'][0]['main'];


          final wind = currentWeatherData['wind']['speed'];
          final humidity = currentWeatherData['main']['humidity'];
          final pressure = currentWeatherData['main']['pressure'];

          
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              //main Card
              SizedBox(
                width: double.infinity,
        
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                  ),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child:   Padding(
                        padding: const EdgeInsets.all(16.0),
                        
                        child: Column(
                          children: [
                            Text(
                              "$currentTemp° C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                        
                            Icon(
                              (currentSky == 'Clouds' || currentSky == 'Rain') ? Icons.cloud : Icons.sunny,
                              size: 64,
                            ),
                            Text(
                              "$currentSky",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                              )
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          
              const SizedBox( height: 20),
          
          
              //weather ForecastCard
              const Align(
                alignment: Alignment.centerLeft,
                child:  Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  ),
              ),
              
              const SizedBox(height: 16),

              // <-----------------------normal type weather loading( pre loading ) -------------->

              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [

              //       for(int i = 1;i<=7;i++)
              //         HourlyForeCastItem(
              //           icon:(data['list'][i]['weather'][0]['main']== 'Clouds' || data['list'][i]['weather'][0]['main']== 'Rain') ? Icons.cloud : Icons.sunny,
              //           time: "${(data['list'][i]['dt_txt']).substring(11,16)}", 
              //           temperature: "${(data['list'][i]['main']['temp']-273.15).toStringAsFixed(2)} C",
              //           ),
        
        
              //     ],
              //   ),
              // ),
              
              //in for loop if we only want to pass one widget no need of brackets , else passs  like this -> for(int i = 0 ;i<n;i++) ...[ widget1 , widget2] 


              // <---------------------------------------------------------end------------------------------------------------------------------------------------------>


              // <------------------------------------------kind of -LazyLoading  (good performace) -------------------------------------------------------------------->


              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context,index){
                
                    final hourlyforecast = data['list'][index+1];
                    final sky = hourlyforecast['weather'][0]['main'];
                    final time =DateTime.parse(hourlyforecast['dt_txt']);

                    return HourlyForeCastItem(
                      icon:(sky== 'Clouds' || sky== 'Rain') ? Icons.cloud : Icons.sunny, 
                      time: DateFormat.j().format(time), 
                      temperature: "${(hourlyforecast['main']['temp']-273.15).toStringAsFixed(2)}° C",
                      );
                
                  }
                  ),
              ),


              // <---------------------------------------------------------end------------------------------------------------------------------------------------------>

              const SizedBox( height: 20),
          
          
              // Additional Information 
        
               const Align(
                alignment: Alignment.centerLeft,
                child:  Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  ),
              ),
        
              const SizedBox(height: 16),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(icon: Icons.water_drop,label: "Humidity", value: "$humidity",),
                  AdditionalInfoItem(icon:Icons.air,label: "Wind", value: "$wind"),
                  AdditionalInfoItem(icon:Icons.beach_access, label: "Pressure", value: "$pressure",),
                ],
        
              ),
          
            ],
            ),
        );
        }
      )
    );
  }
}




