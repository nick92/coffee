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
    private Gee.ArrayList<Weather> _days = null;
    private Post _post = null;
    private Weather _weather = null;
    private Forecast _forecast = null;
    private CoffeeView articleView = null;
    private Worker.Retriever retriever = null;

    private signal void got_location();
    private signal void got_location_error();

    private Gtk.Box box_header;
    private Gtk.Box box_main;
    private Gtk.Button btn_close;
    private Gtk.Button btn_setting;
    private Gtk.Image coffee_img;
    private Gtk.EventBox event_box;
    private Gtk.Spinner spinner;
    private Timer timer;

    private Views.NewsView news_view;
    private Views.WeatherView weather_view;
    //private Widgets.Selector switcher;

    private Widgets.Modality modality;
    public  Gtk.Stack stack;
    public  Widgets.Selector view_selector;
    private Gtk.Revealer view_selector_revealer;

    private Settings.Settings settings;
    private Settings.SettingsWindow settings_window;
    private GLib.Cancellable search_cancellable;

    private Gtk.Revealer location_revealer;
    private Gtk.SearchEntry location_entry;

    private bool weather_loaded = false;
    private bool news_loaded = false;
    private bool reloading = false;

    public SourceFunc callback;

    ulong microseconds;
	  double seconds;

    public CoffeeBar (Gtk.Application coffee){
      this.application = coffee;

      timer = new Timer ();
      retriever = new Worker.Retriever ();
      //articleView = new CoffeeView ();
      _post = Post.get_default ();
      _weather = Weather.get_default ();
      //_forecast = Forecast.get_default ();
      settings = Settings.Settings.get_default ();

      setup_ui();
      connect_methods();

      if(settings.get_location_bool)
        get_location.begin ();

      get_news_feed ();

      this.show_bar ();
    }

    public void get_news_feed (){
      //GLib.Idle.add(this.get_news_feed.callback);
      new Thread<void*> ("get_news", () => {
        retriever.create_fake_news ();
        //retriever.run_parser_news ();
  	    debug ("Got News at: %s s\n", timer.elapsed (out microseconds).to_string ());
        return null;
      });


      if(!settings.get_location_bool || reloading)
      {
        new Thread<void*> ("get_weather", () => {
          retriever.run_parser_weather ();
    	    debug ("Got Weather at: %s s\n", timer.elapsed (out microseconds).to_string ());
          return null;
        });
      }
    }

    public async void get_weather_feed (){
      if(settings.geo_location_string != "") {
        new Thread<void*> ("get_weather", () => {
          retriever.run_parser_weather ();
          debug ("Got Weather at: %s s\n", timer.elapsed (out microseconds).to_string ());
          return null;
        });
      }
      else{
        weather_loaded = true;
        location_revealer.set_reveal_child(true);
      }
    }

    private void display_all () {
      if(news_loaded && weather_loaded)
      {
        //articleView.load_new_html();
        spinner.active = false;
        reloading = false;
      }
    }

    private void load_posts () {
      if(_post.get_count () > 0){
        _posts = _post.get_posts ();

        foreach (var post in _posts) {
            news_view.add_post (post);
        }

        debug ("Added all posts at : %s s\n", timer.elapsed (out microseconds).to_string ());

        news_loaded = true;
        display_all ();
      }
    }

    private void load_weather() {
      if(_weather.get_forecast_count () > 0){
        _days = _weather.get_forecast ();

        /*foreach (var day in _days) {
            articleView.forecast = day;
        }*/

        foreach (var day in _days) {
            weather_view.add_weather (day);
        }
      }

      //weather_view.add_current_weather (_weather);

      debug ("Added all weather at : %s s\n", timer.elapsed (out microseconds).to_string ());

      //articleView.weather = _weather;
      weather_loaded = true;
      display_all ();
    }

    private void reload_posts () {
      spinner.active = true;
      _post.clear_posts();
      //_forecast.clear_forecast ();
      //articleView.reload_articles();
      news_loaded = false;
      weather_loaded = false;
      reloading = true;
      get_news_feed ();
    }

    private void setup_ui (){
      this.title = "Coffee";

      var height = screen.get_height ();
      var width = screen.get_width ();

      // Move the window to the right of the screen
      this.move(width,0);
      this.set_decorated(false);
      this.set_keep_above (false);

      // Sets the default size of a window:
  		this.set_default_size (400, height);
  		this.hide_titlebar_when_maximized = false;

      this.destroy.connect (() => {
        Gtk.main_quit ();
  		});

      spinner = new Gtk.Spinner ();
      spinner.active = true;

      btn_setting = new Gtk.Button ();
      //btn_setting.image = new Gtk.Image.from_icon_name ("application-menu-symbolic", Gtk.IconSize.MENU);
      btn_setting.image = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/preferences-system-symbolic.svg");
      btn_setting.halign = Gtk.Align.START;
      btn_setting.set_relief(Gtk.ReliefStyle.NONE);
      btn_setting.set_tooltip_text ("Coffee Settings");

      coffee_img = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/coffee-news-symbolic.svg");

      btn_close = new Gtk.Button ();
      //btn_close.image = new Gtk.Image.from_icon_name ("view-refresh-symbolic", Gtk.IconSize.MENU);
      btn_close.image = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/window-close-symbolic.svg");
      btn_close.halign = Gtk.Align.END;
      btn_close.set_relief(Gtk.ReliefStyle.NONE);
      btn_close.set_tooltip_text ("Close");

      location_entry = new Gtk.SearchEntry ();
      location_entry.hexpand = true;
      location_entry.margin_left = 15;
      //location_entry.activate.connect (() => {compute_location.begin (location_entry.text);});

      location_revealer = new Gtk.Revealer ();
      location_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
      location_revealer.add (location_entry);

      stack = new Gtk.Stack ();
      stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

      view_selector = new Widgets.Selector (Gtk.Orientation.HORIZONTAL);
      view_selector.margin_top = 6;
      view_selector.margin_bottom = 6;
      view_selector_revealer = new Gtk.Revealer ();
      view_selector_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_RIGHT;
      view_selector_revealer.add (view_selector);
      this.view_selector.selected = 0;

      box_header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      //box_header.margin = 2;
      box_header.set_center_widget (view_selector_revealer);
      box_header.pack_start(btn_setting,false, true, 0);
      box_header.pack_start(spinner,false, true, 0);
      box_header.pack_end(btn_close,true, true, 0);

      news_view = new Views.NewsView ();
      weather_view = new Views.WeatherView ();
      //this.add (event_box);

      stack.add_named (news_view, "news");
      stack.add_named (weather_view, "weather");

      box_main = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
  		box_main.pack_start (box_header, false, false, 0);
      box_main.pack_start (location_revealer, false, false, 0);
  		box_main.pack_start (view_selector_revealer, false, false, 0);
      box_main.pack_start (stack, true, true, 0);

      event_box = new Gtk.EventBox ();
      event_box.add (box_main);
  		this.add (event_box);

      set_modality ((Widgets.Modality) view_selector.selected);
    }

    private void connect_methods(){
      btn_close.clicked.connect (() => {
        //if (main_window != null) {
            clear_tmp_dir ();
            this.destroy ();
            Gtk.main_quit ();
        //}
      });

      view_selector.mode_changed.connect (() => {
          set_modality ((Widgets.Modality) view_selector.selected);
      });

      /*btn_close.clicked.connect (() => {
        if(articleView.can_go_back())
          articleView.go_back();
        else {
          articleView.load_new_html();
        }
      });*/

      btn_setting.clicked.connect (() => {
        if(settings_window == null)
          settings_window = new Settings.SettingsWindow (this.application);

        settings_window.show_all();
        //location_revealer.set_reveal_child (!location_revealer.child_revealed);
      });

      _post.post_add_completed.connect (() => {
          load_posts();
  		});

      _weather.got_weather.connect (() => {
          load_weather();
      });

      this.got_location.connect(() => {
        get_weather_feed ();
      });

      /*_forecast.got_forecast.connect (() => {
          load_weather();
      });*/

      event_box.key_press_event.connect (on_key_press);
    }

    public bool on_key_press (Gdk.EventKey event) {
        var key = Gdk.keyval_name (event.keyval).replace ("KP_", "");

        switch (key) {
            case "F5":
                reload_posts();

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
          var simple = yield new GClue.Simple ("com.github.nick92.coffee", GClue.AccuracyLevel.EXACT, null);

          simple.notify["location"].connect (() => {
              on_location_updated (simple.location.latitude, simple.location.longitude);
          });

          on_location_updated (simple.location.latitude, simple.location.longitude);
      } catch (Error e) {
          debug ("Failed to connect to GeoClue2 service: %s", e.message);
          settings.change_setting_string("N/A - Go to Settings", settings.location_string);
          this.got_location();
          return;
      }
    }

    public void on_location_updated (double latitude, double longitude) {
      if (search_cancellable != null)
          search_cancellable.cancel ();

      search_cancellable = new GLib.Cancellable ();
      var reverse = new Geocode.Reverse.for_location (new Geocode.Location(latitude, longitude, Geocode.LocationAccuracy.REGION));
      try {
          var place = reverse.resolve ();

          if(place.get_area() != null )
            settings.change_setting_string(place.get_area(), settings.location_string);
          else if(place.get_name() != null )
            settings.change_setting_string(place.get_name(), settings.location_string);
          else if(place.get_town() != null )
            settings.change_setting_string(place.get_town(), settings.location_string);
          else if(place.get_street() != null )
            settings.change_setting_string(place.get_street(), settings.location_string);
          else if (place.get_county() != null )
            settings.change_setting_string(place.get_county(), settings.location_string);
          else
            settings.change_setting_string(place.get_country(), settings.location_string);

          settings.change_setting_string(latitude.to_string() +","+ longitude.to_string(), settings.geolocation_string);

          debug ("Got location at : %s s\n", timer.elapsed (out microseconds).to_string ());

          this.got_location();
      } catch (GLib.Error error) {
          debug (error.message);
          this.got_location_error();
      }
    }

    private void set_modality (Widgets.Modality new_modality) {
        modality = new_modality;

        switch (modality) {
            case Widgets.Modality.NEWS_VIEW:

                /*if (Launchy.settings.use_category)
                    Launchy.settings.use_category = false;
                */
                view_selector_revealer.set_reveal_child (true);
                stack.set_visible_child_name ("news");
                break;

            case Widgets.Modality.WEATHER_VIEW:

                /*if (!Launchy.settings.use_category)
                    Launchy.settings.use_category = true;
                    */
                view_selector_revealer.set_reveal_child (true);
                stack.set_visible_child_name ("weather");
                //actions_button.set_active(false);
                break;
        }
    }

    public void clear_tmp_dir ()
    {
      string directory = GLib.Environment.get_tmp_dir () + Path.DIR_SEPARATOR_S + ".coffee";
  		Dir dir = Dir.open (directory, 0);
  		string? name = null;

		  while ((name = dir.read_name ()) != null) {
        File file = File.new_for_path (directory + Path.DIR_SEPARATOR_S + name);
      	try {
      		file.delete ();
      	} catch (Error e) {
      		stdout.printf ("Error: %s\n", e.message);
      	}
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
