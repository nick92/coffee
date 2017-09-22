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

            stack = new Gtk.Stack ();
            //stack.add_titled (new AboutGrid (), "general", "General");
            stack.add_titled (new NewsGrid (), "news", "News");
            stack.add_titled (new LocationGrid (), "location", "Location");

            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.stack = stack;
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.margin = 24;

            grid.attach (stack_switcher, 0, 0, 1, 1);
            grid.attach (stack, 0, 1, 1, 1);
        }
        grid.show ();

        this.add (grid);
      }
  }
}
