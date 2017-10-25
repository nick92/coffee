/*
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
using GLib;

namespace Settings {
  public class Settings : Object {

    public string news_string = "news";
    public string bbc_news_string = "bbc-news";
    public string bbc_sport_string = "bbc-sport";
    public string engadget_string = "engadget";
    public string guardian_string = "the-guardian-uk";
    public string hacker_news_string = "hacker-news";
    public string next_web_string = "the-next-web";
    public string new_york_times_string = "the-new-york-times";
    public string google_news_string = "google-news";

    public bool news_bool {get;set;}
    public bool bbc_news_bool { get; set; }
    public bool bbc_sport_bool { get; set; }
    public bool google_news_bool { get; set; }
    public bool engadget_bool { get; set; }
    public bool guardian_bool { get; set; }
    public bool hacker_news_bool { get; set; }
    public bool next_web_bool { get; set; }
    public bool new_york_times_bool { get; set; }

    public Gee.ArrayList<string> news_sources = null;
    public Gee.ArrayList<string> news_sources_enabled = null;

    public string news_sources_string {get;set;}
    public string news_sources_enabled_string {get;set;}

    public string strNewsSources = "news-sources";
    public string strNewsSourcesEnabled = "news-sources-enabled";

    public string weather_string = "weather";
    public string dark_sky_string = "dark-sky";
    public string open_weather_string = "open-weather-map";
    public string geolocation_string = "geolocation";
    public string location_string = "location";
    public string get_geo_location = "getgeolocation";

    public bool weather_bool {get;set;}
    public bool open_weather_bool {get;set;}
    public bool dark_sky_bool {get;set;}
    public string geo_location_string {get;set;}
    public string location_name_string {get;set;}
    public bool get_location_bool {get;set;}

    private GLib.Settings coffee_settings;

    static Settings instance = null;

    public Settings () {
        this.coffee_settings = new GLib.Settings("com.github.nick92.coffee");
        this.coffee_settings.bind(news_string,this,"news_bool",SettingsBindFlags.DEFAULT);
        /*this.coffee_settings.bind(bbc_news_string,this,"bbc_news_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(bbc_sport_string,this,"bbc_sport_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(google_news_string,this,"google_news_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(engadget_string,this,"engadget_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(guardian_string,this,"guardian_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(hacker_news_string,this,"hacker_news_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(next_web_string,this,"next_web_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(new_york_times_string,this,"new_york_times_bool",SettingsBindFlags.DEFAULT);*/

        this.coffee_settings.bind(weather_string,this,"weather_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(open_weather_string,this,"open_weather_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(dark_sky_string,this,"dark_sky_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(geolocation_string,this,"geo_location_string",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(location_string,this,"location_name_string",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(get_geo_location,this,"get_location_bool",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(strNewsSources,this,"news_sources_string",SettingsBindFlags.DEFAULT);
        this.coffee_settings.bind(strNewsSourcesEnabled,this,"news_sources_enabled_string",SettingsBindFlags.DEFAULT);
    }

    public Gee.ArrayList<string> get_news_sources_random()
    {
      if(news_sources_enabled == null)
        news_sources_enabled = get_news_sources_enabled ();

      List<int> ints = get_random_int(news_sources_enabled.size);
      int v = 0;

      foreach (int i in ints) {
        string news_item_new = news_sources_enabled.get(v);

        news_sources_enabled.remove_at(v);
        news_sources_enabled.insert(i, news_item_new);

        v ++;
      }

      return news_sources_enabled;
    }

    public bool get_news_source_bool (string news_item){
        if(news_sources_enabled != null)
          return news_sources_enabled.contains(news_item);
        else  
          return false;
    }

    public Gee.ArrayList<string> get_news_sources () {
      news_sources = new Gee.ArrayList<string>();
      string[] sources = news_sources_string.split (";");

      foreach (unowned string news in sources) {
        if(news != "")
          news_sources.add(news);
      }

      return news_sources;
    }

    public Gee.ArrayList<string> get_news_sources_enabled () {
      news_sources_enabled = new Gee.ArrayList<string>();
      string[] sources_enabled = news_sources_enabled_string.split (";");

      foreach (unowned string news_en in sources_enabled) {
        if(news_en != "")
          news_sources_enabled.add(news_en);
      }

      return news_sources_enabled;
    }

    public void set_news_source (string news_item)
    {
      string sources = "";

      if(!news_sources.contains(news_item)){
          news_sources.add(news_item);
      }

      foreach (string news in news_sources) {
        if(news != ""){
          sources += news + ";";
        }
      }

      change_setting_string (sources, strNewsSources);
    }

    public void set_news_enabled (bool value, string news_item)
    {
      string sources_enabled = "";

      if(value){
        if(!news_sources_enabled.contains(news_item)){
          news_sources_enabled.add(news_item);
        }
      }
      else{
        if(news_sources_enabled.contains(news_item)){
          news_sources_enabled.remove(news_item);
        }
      }

      foreach (string news in news_sources_enabled) {
        if(news != ""){
          sources_enabled += news + ";";
        }
      }

      change_setting_string (sources_enabled, strNewsSourcesEnabled);
    }

    public List<int> get_random_int(int size)
    {
      List<int> rand_builder = new List<int>();
      Rand rand = new Rand();
      int count = 0;

      while (count < size) {
        int random_int = rand.int_range(0, size);

        if(rand_builder.index(random_int) == -1){
          rand_builder.append(random_int);
          count++;
        }
      }

      return rand_builder;
    }

    public int get_news_count()
    {
      if(news_sources_enabled == null )
        return 1;
      else
        return news_sources_enabled.size;
    }

    public void change_setting_bool (bool value, string setting)
    {
      this.coffee_settings.set_boolean(setting, value);
    }

    public void change_setting_string (string value, string setting)
    {
      this.coffee_settings.set_string(setting, value);
    }

    public static Settings get_default()
    {
      if(instance == null)
        instance = new Settings();

      return instance;
    }
  }
}
