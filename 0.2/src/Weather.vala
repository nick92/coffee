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
using Gtk;

namespace Coffee {
  public class Weather : Object {
    public string weather_img {get; set;}
    public string location {get; set;}
    public int64 temp {get; set;}
    public string text {get; set;}
    public string summary {get; set;}
    public string forecast {get; set;}
    public string day {get; set;}
    public string link {get; set;}

    static Weather? instance = null;

    public signal void got_weather ();

    public Weather (){

    }

    public void got_weather_complete () {
      got_weather();
    }

    public static Weather get_default(){
      if(instance == null)
        instance = new Weather ();

      return instance;
    }
  }
  public class Forecast : Object {
    public string weather_img {get; set;}
    public int64 temp {get; set;}
    public string day {get; set;}

    private Gee.ArrayList<Forecast> days = null;

    static Forecast? instance = null;

    public signal void got_forecast();

    public Forecast (){
      days = new Gee.ArrayList<Forecast>();
    }

    public static Forecast get_default(){
      if(instance == null)
        instance = new Forecast ();

      return instance;
    }

    public void add_day (Forecast forecast)
    {
      days.add(forecast);
    }

    public void clear_forecast ()
    {
      days.clear();
    }

    public void get_forecast_complete()
    {
      got_forecast();
    }

    public Gee.ArrayList<Forecast> get_forecast () {
      if(days == null){
        return new Gee.ArrayList<Forecast>();
      }

      return days;
    }

    public int get_count () {
      return days.size;
    }
  }
}
