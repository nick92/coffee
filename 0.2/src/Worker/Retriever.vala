/*
 * Retriever.vala
 * This file is part of Coffee
 *
 * Copyright (C) 2017 - Nick Wilkins
 *
 * Coffee is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Coffee is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Coffee. If not, see <http://www.gnu.org/licenses/>.
 */
using Geocode;

namespace Worker {
   public class Retriever : Object {

    Parser parser = null;
    Settings.Settings settings;
    Coffee.Post post = null;
    public SourceFunc callback;

    private string apiKey = "e8a66b24da89420b9a419849e95d47a1";
    private string geolocation = "";

    public Retriever () {
      settings = Settings.Settings.get_default();
      post = Coffee.Post.get_default ();
    }

    public async void run_parser_news () {
        //get uri news string and pass Json message to parser
        GLib.Idle.add(this.run_parser_news.callback);
        foreach (string source in settings.get_news_sources_random()) {
            parse_message (source);
        }

        if(post != null){
         post.parse_completed();
       }

         yield;
    }

    public async void run_parser_weather () {
      GLib.Idle.add(this.run_parser_weather.callback);

      if(settings.weather_bool){
        geolocation = settings.geo_location_string;
        if(geolocation != "")
        {
          if(settings.dark_sky_bool)
            parse_message (Sources.DARK_SKY);

          if(settings.open_weather_bool)
            parse_message (Sources.OPEN_WEATHER_MAP);
        }
      }
      yield;
    }

    private void parse_message (string source) {
      var uri = get_source_from_uri(source);
      var session = new Soup.Session ();
      var message = new Soup.Message ("GET", uri);
      session.send_message (message);
      //warning(uri);
      parser = new Parser ();
      parser.parse_message(message, source);
    }

    public string get_source_from_uri(string news_source)
    {
      if(news_source == Sources.DARK_SKY)
        return "https://api.darksky.net/forecast/06446ae7099feacb17ffef78fdf89f0a/" + geolocation + "?units=auto&exclude=[minutely,alerts,flags]";
      else if (news_source == Sources.OPEN_WEATHER_MAP){
        return "http://api.openweathermap.org/data/2.5/weather?lat="+geolocation.split(",")[0]+"&lon="+geolocation.split(",")[1]+"&appid=fa2392a571d54a9d17b1f0f0c934d562&units=metric";
      }
      else
        return "https://newsapi.org/v1/articles?source=" + news_source + "&apiKey=" + apiKey + "";
    }
  }
}
