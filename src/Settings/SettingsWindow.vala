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

      private Settings settings;
      private Gtk.Grid grid;
      private Gtk.Stack stack;
      private NewsGrid news_grid;
      private LocationGrid location_grid;
      private Gtk.Button button_add;


      public SettingsWindow () {
        settings = new Settings ();
        setup_ui();
      }

      public void setup_ui (){
        this.title = "Coffee Settings";

        // Sets the default size of a window:
    		this.set_default_size (800, 600);
    		this.hide_titlebar_when_maximized = false;

        if (grid == null) {
            grid = new Gtk.Grid ();
            grid.margin = 12;

            news_grid = new NewsGrid ();
            location_grid = new LocationGrid ();
            button_add = new Gtk.Button ();

            stack = new Gtk.Stack ();
            //stack.add_titled (new AboutGrid (), "general", "General");
            stack.add_titled (news_grid, "news", "News");
            stack.add_titled (location_grid, "location", "Location");

            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.stack = stack;
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.margin = 24;

            stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT);
            
            stack_switcher.event.connect(() => {
              if(stack.visible_child == location_grid)
              {
                stack.set_transition_type(Gtk.StackTransitionType.SLIDE_RIGHT);
                button_add.visible = false;
              }
              if(stack.visible_child == news_grid)
              {
                stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT);
                button_add.visible = true;
              }
              
              return false;
            });

            button_add.image = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/list-add-symbolic.svg");
            button_add.halign = Gtk.Align.END;
            button_add.set_tooltip_text ("Add news source");
            button_add.set_relief(Gtk.ReliefStyle.NONE);

            button_add.clicked.connect(() => {
            	var news_sources_window = new NewsSourcesList();
        		  news_sources_window.show_all();
        		  news_sources_window.news_added.connect(() => {
        			 news_grid.refresh_news_items();
    			    });
      	    });

            grid.attach (stack_switcher, 0, 0, 1, 1);
            grid.attach (button_add, 0, 1, 1, 1); 
            grid.attach (stack, 0, 2, 1, 1);
        }
        grid.show ();

        this.add (grid);
      }
  }
}
