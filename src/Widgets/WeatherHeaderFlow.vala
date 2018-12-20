// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2014-2017 elementary LLC. (https://elementary.io)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Corentin Noël <corentin@elementaryos.org>
 */
/* Taken from elementary AppCenter */
public class Coffee.Widgets.WeatherHeaderFlowBox : Gtk.FlowBox {
    private Coffee.Weather post;

    public WeatherHeaderFlowBox () {
        Object (activate_on_single_click: true,
                homogeneous: false,
                margin_start: 12,
                margin_top: 10,
                margin_end: 10,
                margin_bottom: 12,
                max_children_per_line: 1);
    }

    construct {
      this.child_activated.connect ((child) => {
        var item = child as Widgets.WeatherHeaderItem;
        if (item != null) {
            //on_launch_url (item.link);
        }
      });
    }

    public void clear () {
      if(get_children ().length().to_string().to_int() > 0){
  				get_children ().foreach ((child) => {
  						remove (child);
  			});
      }
    }

    public void add_weather (Coffee.Weather weather)
    {
        add (get_weather_item (weather));
    }

    private Widgets.WeatherHeaderItem get_weather_item (Coffee.Weather weather) {
        var item = new Widgets.WeatherHeaderItem (weather);
        return item;
    }
}
