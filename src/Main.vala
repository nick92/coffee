/*
 * Main.vala
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

  public class CoffeeApp : Gtk.Application {

    CoffeeBar bar = null;
    static CoffeeApp? app = null;
    const string ACTIVTE_KEY = "F10";
    const string QUIT_KEY = "F4";
    static bool debug = false;
    static bool version = false;

    const OptionEntry[] options = {
			{ "debug", 'd', 0, OptionArg.NONE, ref debug, "Enable debug logging", null },
			{ "version", 'v', 0, OptionArg.NONE, ref version, "Show the application's version", null },
			{ null }
		};

    protected override void activate () {
      var provider = new Gtk.CssProvider ();
      provider.load_from_resource ("com/github/nick92/Coffee/application.css");
      Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

      if (this.get_windows () == null) {
        bar = new CoffeeBar (this);
      }
    }

    public CoffeeApp () {

    }

    public static int main(string[] args) {
        Gtk.init (ref args);

        Plank.Logger.initialize ("coffee");

        if (args.length > 1) {
            var context = new OptionContext ("");
            context.add_main_entries (options, "coffee");
            context.add_group (Gtk.get_option_group (true));

            try {
                context.parse (ref args);
            } catch (Error e) {
                print (e.message + "\n");
            }
        }

  			if (version)
  				Plank.Logger.DisplayLevel = Plank.LogLevel.VERBOSE;
  			else if (debug)
  				Plank.Logger.DisplayLevel = Plank.LogLevel.DEBUG;

        app = new CoffeeApp ();
        return app.run (args);
    }

    public string load_from_resource (string uri) throws IOError, Error {
        var stream = resources_open_stream (uri, ResourceLookupFlags.NONE);
        var dis = new DataInputStream(stream);
        StringBuilder builder = new StringBuilder ();
        string line;
        while ( (line = dis.read_line (null)) != null ) {
            builder.append (line);
        }
        return builder.str.dup ();
    }

    public string load_css_from_resource (string uri, string append) throws IOError, Error {
        var stream = resources_open_stream (uri, ResourceLookupFlags.NONE);
        var dis = new DataInputStream(stream);
        StringBuilder builder = new StringBuilder ();
        string line;
        while ( (line = dis.read_line (null)) != null ) {
            builder.append (line);
        }
        if(append != "")
          builder.append (append);

        return builder.str.dup ();
    }
  }
}
