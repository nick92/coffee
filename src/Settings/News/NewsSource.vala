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
  public class News.NewsSource : Object {

    private Gee.ArrayList<NewsSource> sources = null;

    static NewsSource? instance = null;

    public string id { get; set; }
    public string name { get; set; }
    public string description { get; set; }
    public string category { get; set; }
    public string country { get; set; }
    public string language { get; set; }
    public string url { get; set; }
    public string besticon_url { get; set; }

    public signal void get_sources_completed ();

    public signal void new_source (NewsSource source);

    public NewsSource () {
      sources = new Gee.ArrayList<NewsSource>();
    }

    public static NewsSource get_default () {
      if (instance == null) {
          instance = new NewsSource ();
      }

      return instance;
    }

    public void add_source (NewsSource source)
    {
      sources.add(source);
      new_source (source);
    }

    public void clear ()
    {
      sources.clear();
    }

    public void parse_completed ()
    {
      get_sources_completed ();
    }

    public Gee.ArrayList<NewsSource> get_sources () {
      if(sources == null){
        return new Gee.ArrayList<NewsSource>();
      }

      return sources;
    }

    public int get_count () {
      return sources.size;
    }
  }
}
