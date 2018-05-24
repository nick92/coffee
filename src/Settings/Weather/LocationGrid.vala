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

namespace Settings {
  public class Weather.LocationGrid : Grid {

    private Gtk.SearchEntry location_entry;
    private Gtk.Switch _switch_location;
    private Gtk.Switch _switch_weather;
    private Gtk.Switch _switch_dark_sky;
    private Gtk.Switch _switch_openweathermap;
    private Gtk.Image location_error;
    private Gtk.Spinner loading_spinner;

    private GLib.Cancellable search_cancellable;
    private Settings settings;

    public LocationGrid () {
      column_spacing = 12;
      halign = Gtk.Align.CENTER;
      row_spacing = 6;
      margin_start = margin_end = 6;

      settings = Settings.get_default ();
      location_entry = new Gtk.SearchEntry ();
      _switch_location = new Gtk.Switch ();
      _switch_weather = new Gtk.Switch ();

      _switch_dark_sky = new Gtk.Switch ();
      _switch_openweathermap = new Gtk.Switch ();

      if(settings.get_location_bool)
        _switch_location.active = true;
      if(settings.dark_sky_bool)
        _switch_dark_sky.active = true;
      if(settings.open_weather_bool)
        _switch_openweathermap.active = true;

      _switch_openweathermap.halign = Gtk.Align.END;
      _switch_dark_sky.halign = Gtk.Align.END;
      _switch_location.halign = Gtk.Align.END;
      _switch_weather.halign = Gtk.Align.END;

      if(settings.location_name_string == "")
        location_entry.placeholder_text = "London, UK";
      else
        location_entry.placeholder_text = settings.location_name_string;

      loading_spinner = new Gtk.Spinner ();
      loading_spinner.active = false;

      location_entry.hexpand = true;
      location_entry.margin_left = 15;
      location_entry.activate.connect (() => {compute_location.begin (location_entry.text);});

      /*grid_1.margin = 5;
      grid_1.attach(new Gtk.Label("Location"), 0, 0, 1, 1);
      grid_1.attach(location_entry, 1, 0, 1, 1);*/

      var location_label = new Gtk.Label("Location:");
      location_label.halign = Gtk.Align.END;

      var weather_label = new Gtk.Label("Weather:");
      weather_label.halign = Gtk.Align.END;

      var find_location_label = new Gtk.Label("Automatic Location:");
      find_location_label.halign = Gtk.Align.END;

      var open_weather_label = new Gtk.Label("Use Open Weather Map:");
      open_weather_label.halign = Gtk.Align.END;

      var use_dark_sky_label = new Gtk.Label("Use Dark Sky:");
      use_dark_sky_label.halign = Gtk.Align.END;

      location_error = new Gtk.Image.from_icon_name("error", Gtk.IconSize.LARGE_TOOLBAR);
      use_dark_sky_label.halign = Gtk.Align.START;
      location_error.opacity = 0;

      connect_events ();
      //attach(weather_label, 1, 0, 1, 1);
      //attach(_switch_weather, 2, 0, 1, 1);
      attach(location_label, 1, 1, 1, 1);
      attach(location_entry, 2, 1, 1, 1);
      attach(loading_spinner, 3, 1, 1, 1);
      attach(location_error, 4, 1, 1, 1);
      attach(find_location_label, 1, 2, 1, 1);
      attach(_switch_location, 2, 2, 1, 1);
      //attach(open_weather_label, 1, 3, 1, 1);
      //attach(_switch_openweathermap, 2, 3, 1, 1);
      //attach(use_dark_sky_label, 1, 4, 1, 1);
      //attach(_switch_dark_sky, 2, 4, 1, 1);
    }

    private void connect_events () {
      _switch_location.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_location.active, settings.get_geo_location);
      });
      _switch_openweathermap.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_openweathermap.active, settings.open_weather_string);
      });
      _switch_dark_sky.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_dark_sky.active, settings.dark_sky_string);
      });
    }

    private async void compute_location (string loc) {
      if (search_cancellable != null)
          search_cancellable.cancel ();

      loading_spinner.active = true;
      _switch_location.active = false;

      search_cancellable = new GLib.Cancellable ();
      var forward = new Geocode.Forward.for_string (loc);
      try {
          forward.set_answer_count (1);
          var places = yield forward.search_async (search_cancellable);
          foreach (var place in places) {
              settings.change_setting_string(place.name, settings.location_string);
              settings.change_setting_string(place.location.latitude.to_string() +","+ place.location.longitude.to_string(), settings.geolocation_string);
          }
          location_entry.has_focus = true;
          location_error.opacity = 0;
          loading_spinner.active = false;
      } catch (GLib.Error error) {
          location_error.opacity = 1;
          location_error.set_tooltip_text(error.message);
          loading_spinner.active = false;
          warning (error.message);
      }
    }
  }
}
