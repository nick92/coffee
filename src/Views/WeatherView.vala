/*
 * HomeView.vala
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
  public class Views.WeatherView : Stack {
    Widgets.WeatherFlowBox weather_flow;
    private Gtk.ScrolledWindow weather_scrolled;

    construct {
      weather_flow = new Widgets.WeatherFlowBox ();

      weather_scrolled = new Gtk.ScrolledWindow (null, null);
      weather_scrolled.set_overlay_scrolling(true);
      weather_scrolled.add (weather_flow);

      add (weather_scrolled);
    }

    public void add_weather (Coffee.Weather weather) {
      weather_flow.add_weather (weather);
    }
  }
}
