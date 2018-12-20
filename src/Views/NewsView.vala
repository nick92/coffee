/*
 * NewsView.vala
 * This file is part of Coffee
 *
 * Copyright (C) 2018 - Nick Wilkins
 *
 * Coffee is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * news is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Coffee. If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;

namespace Coffee {
  public class Views.NewsView : Stack {
    Widgets.NewsFlowBox news_flow;
    Widgets.WeatherHeaderFlowBox weather_header_flow;
    private Gtk.ScrolledWindow news_scrolled;

    construct {
      news_flow = new Widgets.NewsFlowBox ();
      weather_header_flow = new Widgets.WeatherHeaderFlowBox ();

      var box_view = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      box_view.add (weather_header_flow);
      box_view.add (news_flow);

      news_scrolled = new Gtk.ScrolledWindow (null, null);
      news_scrolled.set_overlay_scrolling(true);
      news_scrolled.add (box_view);

      add (news_scrolled);
    }

    public void clear_rows ()
    {
      news_flow.clear();
      weather_header_flow.clear();
    }

    public void on_launch_url (string uri)
    {
      try {
          AppInfo.launch_default_for_uri (uri, null);
      } catch (Error e) {
          warning ("%s\n", e.message);
      }
    }

    public void add_post (Coffee.Post post) {
      news_flow.add_post (post);
    }

    public void add_weather_header (Coffee.Weather weather) {
      weather_header_flow.add_weather (weather);
    }
  }
}
