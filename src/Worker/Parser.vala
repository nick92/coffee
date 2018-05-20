/*
 * Parser.vala
 * This file is part of Coffee
 *
 * Copyright (C) 2017 - Nick Wilkins
 *
 * Coffee is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * news is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Coffee. If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;

namespace Worker {
  public class Parser : Object {

    Coffee.Post post = null;
    Settings.Settings settings = null;
    int intNews = 0;

    public Parser (){
      post = Coffee.Post.get_default();
      settings = Settings.Settings.get_default ();
      intNews = 15 / settings.get_news_count();
    }

    public void parse_message (Soup.Message message, string source){
      try {
          var parser = new Json.Parser ();
          parser.load_from_data ((string) message.response_body.flatten ().data, -1);
          var root_object = parser.get_root ().get_object();

          if(source == Sources.DARK_SKY){
            //var current = root_object.get_object_member ("hourly");
            //var forecast = root_object.get_object_member ("daily");

            parse_weather(root_object);
            //parse_forecast(forecast);
          }
          else{
            var response = root_object.get_array_member ("articles");
            parse_news(response);
          }
      } catch (Error e) {
           stderr.printf ("I guess something is not working...\n");
      }
    }

    public void parse_news (Json.Array response){
        int i = 0;

        foreach (var geonode in response.get_elements ()) {
             var geoname = geonode.get_object ();
             var new_post = new Coffee.Post();
             new_post.title = geoname.get_string_member ("title");
             new_post.image_link = geoname.get_string_member ("urlToImage");
             new_post.subject = geoname.get_string_member ("description");
             new_post.author = geoname.get_string_member ("author");
             new_post.link = geoname.get_string_member ("url");

             if(i==intNews)
              return;

             if(post != null)
                post.add_post (new_post);

             i++;
         }
    }

    public void parse_reddit (Json.Array response)
    {
      //TODO https://www.reddit.com/.json?r=upliftingnews
    }

    public void parse_weather (Json.Object response)
    {
        var dt = new DateTime.now_local ();
        var today = dt.get_day_of_week ();

        var current = response.get_object_member ("hourly");
        var forecast = response.get_object_member ("daily");

        var _weather = Coffee.Weather.get_default();

        var weather = new Coffee.Weather ();
        weather.location = settings.location_name_string;
        weather.link = "https://darksky.net/forecast/"+settings.geo_location_string;
        weather.temp = current.get_array_member ("data").get_object_element(0).get_int_member ("temperature").to_string ();
        weather.text = current.get_array_member ("data").get_object_element(0).get_string_member ("summary");
        weather.day = "Today";
        weather.summary = current.get_string_member ("summary");
        weather.weather_img = get_weather_icon(current.get_array_member ("data").get_object_element(0).get_string_member ("icon"), "weather");

        _weather.add_day (weather);

        var forecast_data = forecast.get_array_member ("data");
        int i = 0;

        foreach (var geonode in forecast_data.get_elements ()) {
          if(i!=0 && i<6){
            var geoname = geonode.get_object ();
            var _newForecast = new Coffee.Weather ();
            _newForecast.location = settings.location_name_string;
            _newForecast.day = get_day(today+i);
            _newForecast.summary = geoname.get_string_member ("summary");
            _newForecast.text = geoname.get_string_member ("summary");
            //_newForecast.text = geoname.get_array_member ("data").get_object_element(0).get_string_member ("summary");
            _newForecast.weather_img = get_weather_icon(geoname.get_string_member ("icon"), "forecast");
            _newForecast.temp = "H " + geoname.get_int_member ("temperatureHigh").to_string () + "°" + " L " + geoname.get_int_member ("temperatureLow").to_string () + "°";
            if(_weather != null)
              _weather.add_day(_newForecast);
          }
          i++;
        }

        _weather.got_weather_complete();
    }

    public void parse_forecast (Json.Object response)
    {
      var _forecast = Coffee.Forecast.get_default ();

      var forecast = response.get_array_member ("data");
      int i = 0;
      var dt = new DateTime.now_local ();
      var today = dt.get_day_of_week ();

      foreach (var geonode in forecast.get_elements ()) {
        if(i!=0 && i<6){
          var geoname = geonode.get_object ();
          var _newForecast = new Coffee.Forecast();
          _newForecast.day = get_day(today+i);
          _newForecast.weather_img = get_weather_icon(geoname.get_string_member ("icon"), "forecast");
          _newForecast.temp = geoname.get_int_member ("temperatureHigh");
          if(_forecast != null)
            _forecast.add_day(_newForecast);
        }
        i++;
      }
      _forecast.got_forecast();
    }

    public string get_weather_icon (string weather_icon, string type)
    {
        // cloud - https://i.imgur.com/ekp2WBm.png
        // cloud more sun - https://i.imgur.com/SeLfWTW.png
        // cloud less sun - https://i.imgur.com/bUkZ8yH.png
        // sun & rain - https://i.imgur.com/99iheuP.png
        // rain - https://i.imgur.com/KthJH0z.png
        // sun - https://i.imgur.com/MnNA9E4.png

        //clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night
        switch (weather_icon) {
          case "clear-day":
            return "https://i.imgur.com/r083aDL.png";
          case "clear-night":
            return "https://i.imgur.com/PDSgawm.png";
          case "rain":
            return "https://i.imgur.com/kBB5AYF.png";
          case "snow":
            return "https://i.imgur.com/e8oIEco.png";
          case "sleet":
            return "https://i.imgur.com/zHVmfxD.png";
          case "wind":
            return "https://i.imgur.com/S8Ocs4Z.png";
          case "fog":
            return "https://i.imgur.com/4VFO9y0.png";
          case "cloudy":
            return "https://i.imgur.com/Gshutca.png";
          case "partly-cloudy-day":
            return "https://i.imgur.com/KczFfy0.png";
          case "partly-cloudy-night":
            if(type=="forecast")
              return "https://i.imgur.com/KczFfy0.png";
            else
              return "https://i.imgur.com/ZYjrxaA.png";
          default:
            return "https://i.imgur.com/KczFfy0.png";
        }
    }

    public string get_day (int day_number)
    {
      if(day_number > 7)
        day_number = day_number - 7;

      switch(day_number)
      {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
      }

      return "N/A";
    }
  }
}
