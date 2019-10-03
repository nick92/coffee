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
using GLib;

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
        foreach (string source in settings.get_news_sources_random()) {
            parse_message (source);
        }

        if(post != null){
          post.parse_completed();
        }
    }

    public async void run_parser_weather () {
      if(settings.weather_bool){
        geolocation = settings.geo_location_string;
        if(geolocation != "")
        {
          if(settings.dark_sky_bool)
            parse_message (Sources.DARK_SKY);

          //if(settings.open_weather_bool)
            //parse_message (Sources.OPEN_WEATHER_MAP);

          //  Idle.add(this.run_parser_weather.callback);
        }
      }
      //  yield;
    }

    public void create_fake_news () {
      var new_post = new Coffee.Post();
      new_post.title = "Mnuchin, Navarro got into 'screaming match' on China trip | Trump's infrastructure plan hits dead end";
      new_post.image_link = "http://s.marketwatch.com/public/resources/MWimages/MW-GI625_mnuchi_ZG_20180504175155.jpg";
      new_post.subject = "Top Trump aides reportedly got into a ‘screaming match’ on a China trip; President Trump’s infrastructure plan at a dead end; and what a former Treasury official said about a story involving the department and Michael Cohen.";
      new_post.author = "Robert Schroeder";
      new_post.link = "https://www.marketwatch.com/story/mnuchin-navarro-got-into-screaming-match-on-china-trip-trumps-infrastructure-plan-hits-dead-end-2018-05-17";

      post.add_post (new_post);

      var new_post2 = new Coffee.Post();
      new_post2.title = "North Korea turns on 'incompetent' South";
      new_post2.image_link = "https://ichef.bbci.co.uk/news/1024/branded_news/1011D/production/_101612856_mediaitem101612855.jpg";
      new_post2.subject = "Angry at US military drills, Pyongyang says it will not talk to South Korea until issues are settled.";
      new_post2.author = "BBC News";
      new_post2.link = "https://www.marketwatch.com/story/mnuchin-navarro-got-into-screaming-match-on-china-trip-trumps-infrastructure-plan-hits-dead-end-2018-05-17";

      post.add_post (new_post2);

      var new_post3 = new Coffee.Post();
      new_post3.title = "Girl found dead after migrant van chase";
      new_post3.image_link = "https://ichef.bbci.co.uk/news/1024/branded_news/16B70/production/_101604039_gettyimages-516477472.jpg";
      new_post3.subject = "A young girl's body is discovered after Belgian police pursue a van carrying up to 30 migrants, reports say";
      new_post3.author = "BBC News";
      new_post3.link = "https://www.marketwatch.com/story/mnuchin-navarro-got-into-screaming-match-on-china-trip-trumps-infrastructure-plan-hits-dead-end-2018-05-17";

      post.add_post (new_post3);

      post.parse_completed();
    }

    private void parse_message (string source) {
      var uri = get_source_from_uri(source);
      var session = new Soup.Session ();
      var message = new Soup.Message ("GET", uri);
      session.send_message (message);
      parser = new Parser ();
      parser.parse_message(message, source);
    }

    public string get_source_from_uri(string news_source)
    {
      if(news_source == Sources.DARK_SKY)
        return "https://api.darksky.net/forecast/06446ae7099feacb17ffef78fdf89f0a/" + geolocation + "?units=auto&exclude=[minutely,alerts,flags]";
      else if (news_source == Sources.OPEN_WEATHER_MAP) {
        return "http://api.openweathermap.org/data/2.5/weather?lat="+geolocation.split(",")[0]+"&lon="+geolocation.split(",")[1]+"&appid=fa2392a571d54a9d17b1f0f0c934d562&units=metric";
      }
      else {
        return "https://newsapi.org/v2/top-headlines?sources=" + news_source + "&apiKey=" + apiKey + "";
        //return "https://newsapi.org/v1/articles?source=" + news_source + "&apiKey=" + apiKey + "";
      }
    }
  }
}
