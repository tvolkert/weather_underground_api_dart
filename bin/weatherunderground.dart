import "dart:io";
import "dart:json";
import "dart:async";
import "dart:collection";

class WeatherUnderground {
  const _apiURL= "http://api.wunderground.com/api/";
  String _apiKey;
  String _locQuery;
  HttpClient _client;
  Map _apiMap = {'alerts': 'alerts',
                 'almanac': 'almanac',
                 'astronomy': 'moon_phase',
                 'conditions': 'current_observation',
                 'currenthurricane': 'currenthurricane',
                 'forecast': 'forecast',
                 'forecast10day': 'forecast',
                 'geolookup': 'location',
                 'history': 'history',
                 'hourly': 'hourly_forecast',
                 'hourly10day': 'hourly_forecast'};
  
  void setLocationQuery(String locationQuery) {
    _locQuery = locationQuery;
  }
  
  WeatherUnderground(String apiKey, String locationQuery) {
    _apiKey = apiKey;
    setLocationQuery(locationQuery);
    _client = new HttpClient();
  }
  
  Future getAlmanac() {
    return makeAPICall('almanac');
  }
  
  Future getAlerts() {
    return makeAPICall('alerts');
  }
  
  Future getAstronomy() {
    return makeAPICall('astronomy');
  }
  
  Future getConditions() {
    return makeAPICall('conditions');
  }
  
  Future getCurrentHurricane() {
    return makeAPICall('currenthurricane');
  }
  
  Future getForecast() {
    return makeAPICall('forecast');
  }
  
  Future getForecast10Day() {
    return makeAPICall('forecast');    
  }
  
  Future getGeoLookup() {
    return makeAPICall('geolookup');
  }
  
  Future getHistory(DateTime when) {
    String s = "";
    s = when.year.toString();
    if(when.month < 10) {
      s = s + "0";
    }
    s = s + when.month.toString();
    if(when.day < 10) {
      s = s + "0";
    }
    s = s + when.day.toString();
    return makeAPICall('history_${s}');
  }
  
  Future getHourly() {
    return makeAPICall('hourly');
  }
  
  Future getHourly10Day() {
    return makeAPICall('hourly10day');
  }  

  Future makeAPICall(String apiName) {
    Completer completer = new Completer();
    
    String query = _apiURL + _apiKey + "/" + apiName + "/q/" + _locQuery + ".json";
    _client.getUrl(Uri.parse(query))
      .then((HttpClientRequest request) {
        return request.close();
      })
      .then((HttpClientResponse response) {
        response.transform(new StringDecoder()).toList().then((data) {
          String body = data.join('');
          LinkedHashMap parsedList = parse(body);
          String dataKey = parsedList['response']['features'].keys.first; 
          print(parsedList.toString()); 
          completer.complete(parsedList[_apiMap[dataKey]]);       
        });        
      });
    return completer.future;
  }
}