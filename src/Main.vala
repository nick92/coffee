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

    protected override void activate () {
      bar = new CoffeeBar ();
      bar.set_application(this);
      connect_events();
    }

    public void connect_events () {
      /*Keybinder.init();
      Keybinder.bind(ACTIVTE_KEY, Coffee.bind_key, bar);

      this.window_removed.connect(() => {
        show_notification("Coffee Closed", "Handling key %s unbound".printf(ACTIVTE_KEY));
        unblind_key ();
      });*/
    }

    public CoffeeApp () {
      //Notify.init ("Coffee");
      //show_notification("Coffee Started", "Press %s to hide / show.\n".printf(ACTIVTE_KEY));
    }

    public static int main(string[] args) {
        Gtk.init (ref args);

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
