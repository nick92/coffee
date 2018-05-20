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
      //add (get_category (_("Some new article with some text"), "audio-speakers", {"Audio"}, "audio"));
      /*add (get_category (_("Development"), "applications-development", {"IDE", "Development"}, "development"));
      add (get_category (_("Audio"), "audio-speakers", {"Audio"}, "audio"));
      add (get_category (_("Development"), "applications-development", {"IDE", "Development"}, "development"));*/
    }

    public void add_post (Coffee.Post post)
    {
      //post.get_posts ().foreach ((post) => {
        add (get_category (post));
        //return false;
      //});
    }

    private Widgets.NewsItem get_category (Coffee.Post post) {

        var item = new Widgets.NewsItem (post);
        //item.add_category_class (style);

        return item;
    }
}
