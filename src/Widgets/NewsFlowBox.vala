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
public class Coffee.Widgets.NewsFlowBox : Gtk.FlowBox {
    private Coffee.Post post;

    public NewsFlowBox () {
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
        var item = child as Widgets.NewsItem;
        if (item != null) {
            on_launch_url (item.post.link);
        }
      });
    }

    public void on_launch_url (string uri){
      try {
          AppInfo.launch_default_for_uri (uri, null);
      } catch (Error e) {
          warning ("%s\n", e.message);
      }
    }

    public void add_post (Coffee.Post post)
    {
        add (get_category (post));
    }

    private Widgets.NewsItem get_category (Coffee.Post post) {
        var item = new Widgets.NewsItem (post);

        return item;
    }
}
