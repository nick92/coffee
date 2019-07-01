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
using Geocode;

namespace Settings {
  public class SettingsWindow : Window {
      public Coffee.CoffeeBar bar {get;construct;}

      private Settings settings;
      private Gtk.Grid grid;
      private Gtk.Stack stack;
      private News.NewsGrid news_grid;
      private Weather.LocationGrid location_grid;
      private General.AboutGrid about_grid;
      private Coffee.MessageDialog welcome_dialog;
      public bool is_open = false;


      public SettingsWindow (Coffee.CoffeeBar bar) {
        Object(bar: bar);
        this.transient_for = bar;
        settings = new Settings ();

        this.destroy.connect (() => {   
          is_open = false;
        });
      }

      public void setup_ui (){
        this.title = "Settings";

        // Sets the default size of a window:
    		this.set_default_size (900, 600);
        this.window_position = Gtk.WindowPosition.CENTER;
    		this.hide_titlebar_when_maximized = false;

        if(settings.first_load_bool) {
          welcome_dialog = new Coffee.MessageDialog.with_image_from_icon_name (this, "Welcome", "Please select news feeds and location to begin ...", "dialog-information" , Gtk.ButtonsType.OK );
          welcome_dialog.show_all();
          welcome_dialog.response.connect (on_response);
        }

        if(settings.get_news_count() == 0 && !settings.first_load_bool){
          welcome_dialog = new Coffee.MessageDialog.with_image_from_icon_name (this, "Select News Sources", "You have no selected news items, please choose some ...", "dialog-information" , Gtk.ButtonsType.OK );
          welcome_dialog.show_all();
          welcome_dialog.response.connect (on_response);

          settings.first_load_bool = true;
        }

        grid = new Gtk.Grid ();
        grid.margin = 12;

        news_grid = new News.NewsGrid ();
        about_grid = new General.AboutGrid ();
        location_grid = new Weather.LocationGrid ();

        news_grid.button_add.clicked.connect(() => {
          var news_sources_window = new News.NewsSourcesList (this);
          news_sources_window.show_all();
          news_sources_window.news_added.connect(() => {
            news_grid.refresh_news_items();
            //news_sources_window.close();
          });
        });

        news_grid.button_refresh.clicked.connect(() => {
          bar.reload_posts();
        });

        news_grid.button_launch.clicked.connect(() => {
          //var coffeebar = new Coffee.CoffeeBar(this.get_application());
          bar.launch();
          
          settings.first_load_bool = false;
          this.destroy();
        });

        stack = new Gtk.Stack ();
        //stack.add_titled (about_grid, "general", "General");
        stack.add_titled (news_grid, "news", "News");
        stack.add_titled (location_grid, "location", "Weather");

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.stack = stack;
        stack_switcher.halign = Gtk.Align.CENTER;
        stack_switcher.margin = 24;

        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        grid.attach (stack_switcher, 0, 0, 1, 1);
        grid.attach (stack, 0, 2, 1, 1);

        this.add (grid);
      }

      public void open() {
        if(!is_open) {
          setup_ui();
          this.show_all();
          is_open = true;
        }
      }

      private void on_response (Gtk.Dialog source, int response_id) {
    		switch (response_id) {
      		case Gtk.ResponseType.OK:
      			welcome_dialog.close ();
      			break;
      		}
    	}
  }
}
