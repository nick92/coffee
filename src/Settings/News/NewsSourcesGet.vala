/*
* Copyright (C) 2018 - Nick Wilkins
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
using Gtk;

namespace Settings {
  public class NewsSourceGet : Object {

    private string sources_uri = "https://newsapi.org/v2/sources?apiKey=e8a66b24da89420b9a419849e95d47a1";
    private NewsSource news_sources;

    construct {
        news_sources = NewsSource.get_default ();
        sources_parse ();
    }

    private void sources_parse () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", sources_uri);
        session.send_message (message);
        parse_message(message);
    }

    private void parse_message (Soup.Message message){
      try {
          var parser = new Json.Parser ();
          parser.load_from_data ((string) message.response_body.flatten ().data, -1);
          var root_object = parser.get_root ().get_object();
          var response = root_object.get_array_member ("sources");
          add_sources(response);
      } catch (Error e) {
           stderr.printf ("I guess something is not working...\n");
      }
    }

    private void add_sources (Json.Array response){
      int i = 0;

      foreach (var geonode in response.get_elements ()) {
        var geoname = geonode.get_object ();
        var news_source = new NewsSource ();
        news_source.id = geoname.get_string_member ("id");
        news_source.name = geoname.get_string_member ("name");
        news_source.description = geoname.get_string_member ("description");
        news_source.url = geoname.get_string_member ("url");
        news_source.category = geoname.get_string_member ("category");
        news_source.country = geoname.get_string_member ("country");

        news_sources.add_source (news_source);
      }
    }
  }
}
