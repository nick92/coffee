/*
 * CoffeeBar.vala
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

using Gtk;

namespace Coffee {
  public class CoffeeBar : Window {

    private Gee.ArrayList<Post> _posts = null;
    private Gee.ArrayList<Forecast> _days = null;
    private Post _post = null;
    private Weather _weather = null;
    private Forecast _forecast = null;
    private CoffeeView articleView = null;
    private Worker.Retriever retriever = null;

    private signal void got_location();

    private Gtk.Box box_header;
    private Gtk.Box box_main;
    private Gtk.Button btn_return;
    private Gtk.Button btn_setting;
    private Gtk.Image coffee_img;
    private Gtk.EventBox event_box;
    private Gtk.Spinner spinner;

    private Settings.Settings settings;
    private GLib.Cancellable search_cancellable;

    private bool weather_loaded = false;
    private bool news_loaded = false;

    public SourceFunc callback;

    public CoffeeBar (){
      retriever = new Worker.Retriever ();
      articleView = new CoffeeView ();
      _post = Post.get_default ();
      _weather = Weather.get_default ();
      _forecast = Forecast.get_default ();
      settings = Settings.Settings.get_default ();

      setup_ui();
      connect_methods();

      if(settings.get_location_bool)
        get_location.begin ();

      get_news_feed.begin ();

      this.show_bar ();

      //this.show_bar ();
    }

    public async void get_news_feed (){
      //GLib.Idle.add(this.get_news_feed.callback);
      warning("get_news_feed");
      retriever.run_parser_news ();

      if(!settings.get_location_bool)
        retriever.run_parser_weather ();

      //yield;
    }

    public async void get_weather_feed (){
      warning("get_weather_feed");
      retriever.run_parser_weather ();
    }

    private void display_all () {
      warning(news_loaded.to_string() + weather_loaded.to_string());
      if(news_loaded && weather_loaded)
      {
        warning("display_all");
        articleView.load_new_html();
        spinner.active = false;
      }
    }

    private void load_posts () {
      if(_post.get_count () > 0){
        _posts = _post.get_posts ();

        foreach (var post in _posts) {
            articleView.post = post;
        }
        news_loaded = true;
        display_all ();
      }
    }

    private void load_weather() {
      if(_forecast.get_count () > 0){
        _days = _forecast.get_forecast ();

        foreach (var day in _days) {
            articleView.forecast = day;
        }
      }
      articleView.weather = _weather;
      weather_loaded = true;
      display_all ();
    }

    private void reload_posts () {
      spinner.active = true;
      _post.clear_posts();
      _forecast.clear_forecast ();
      articleView.reload_articles();
      news_loaded = false;
      weather_loaded = false;

      //if(settings.get_location_bool)
        //get_location.begin ();
      get_weather_feed.begin ();  
      get_news_feed.begin ();
    }

    private void setup_ui (){
      this.title = "Coffee";
      var screen = Gdk.Screen.get_default ();
      var height = screen.get_height ();
      var width = screen.get_width ();

      // Move the window to the right of the screen
      this.move(width,0);
      this.set_decorated(false);
      this.set_keep_above (true);

      // Sets the default size of a window:
  		this.set_default_size (400, height);
  		this.hide_titlebar_when_maximized = false;
  		this.destroy.connect (() => {
        Gtk.main_quit ();
  		});

      spinner = new Gtk.Spinner ();
      spinner.active = true;

      btn_setting = new Gtk.Button ();
      btn_setting.image = new Gtk.Image.from_icon_name ("application-menu-symbolic", Gtk.IconSize.MENU);
      btn_setting.halign = Gtk.Align.END;
      btn_setting.set_relief(Gtk.ReliefStyle.NONE);

      coffee_img = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/coffee-news-symbolic.svg");

      btn_return = new Gtk.Button ();
      btn_return.image = new Gtk.Image.from_icon_name ("view-refresh-symbolic", Gtk.IconSize.MENU);
      btn_return.halign = Gtk.Align.START;
      btn_return.set_relief(Gtk.ReliefStyle.NONE);

      box_header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      //box_header.margin = 2;
      box_header.set_center_widget (coffee_img);
      box_header.pack_start(btn_return,false, true, 0);
      box_header.pack_start(spinner,false, true, 0);
      box_header.pack_end(btn_setting,true, true, 0);

      //this.add (event_box);

      box_main = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  		box_main.pack_start (box_header, false, false, 0);
  		box_main.pack_start (articleView, true, true, 0);

      event_box = new Gtk.EventBox ();
      event_box.add (box_main);
  		this.add (event_box);
    }

    private void connect_methods(){
      btn_return.clicked.connect (() => {
        reload_posts();
      });

      /*btn_return.clicked.connect (() => {
        if(articleView.can_go_back())
          articleView.go_back();
        else {
          articleView.load_new_html();
        }
      });*/

      btn_setting.clicked.connect (() => {
        var settings_window = new Settings.SettingsWindow();
        settings_window.show_all();
      });

      _post.post_add_completed.connect (() => {
          warning("got posts");
          load_posts();
  		});

      _weather.got_weather.connect (() => {
          //load_weather();
      });

      this.got_location.connect(() => {
        get_weather_feed ();
      });

      _forecast.got_forecast.connect (() => {
          warning("got weather");
          load_weather();
      });

      event_box.key_press_event.connect (on_key_press);
    }

    public bool on_key_press (Gdk.EventKey event) {
        var key = Gdk.keyval_name (event.keyval).replace ("KP_", "");

        switch (key) {
            case "F4":
                destroy();

                break;

            case "Escape":
                  destroy ();

                return true;

            case "F10":
                  show_bar ();

                return true;
          }

        return true;
    }

    public async void get_location () {
      try {
          warning("this.got_location();");
          var simple = yield new GClue.Simple ("com.github.nick92.coffee", GClue.AccuracyLevel.CITY, null);

          simple.notify["location"].connect (() => {
              on_location_updated (simple.location.latitude, simple.location.longitude);
          });

          on_location_updated (simple.location.latitude, simple.location.longitude);
      } catch (Error e) {
          debug ("Failed to connect to GeoClue2 service: %s", e.message);
          return;
      }
    }

    public void on_location_updated (double latitude, double longitude) {
      if (search_cancellable != null)
          search_cancellable.cancel ();

      //warning("this.got_location();");
      search_cancellable = new GLib.Cancellable ();
      var reverse = new Geocode.Reverse.for_location (new Geocode.Location(latitude, longitude, Geocode.LocationAccuracy.CITY));
      try {
          var place = reverse.resolve ();
          settings.change_setting_string(place.get_area(), settings.location_string);
          settings.change_setting_string(latitude.to_string() +","+ longitude.to_string(), settings.geolocation_string);
          this.got_location();
      } catch (GLib.Error error) {
          debug (error.message);
      }
    }

    public void show_bar ()
    {
      if(this.is_visible())
        hide ();
      else {
        this.show_all();
      }
    }
  }
}
