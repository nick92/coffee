/*
* Copyright (C) 2018 - Nick Wilkins
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

namespace Settings {
  public class News.NewsListRow : Gtk.ListBoxRow {
    public NewsSource news_source { get; construct; }
    private Gtk.Grid info_grid;

    public NewsListRow (NewsSource news_source) {
      Object (news_source : news_source);
    }

    construct {
        column_spacing = 24;
        margin = 6;
        margin_start = 12;
        margin_end = 12;

        image.icon_size = Gtk.IconSize.DIALOG;
        /* Needed to enforce size on icons from Filesystem/Remote */
        image.pixel_size = 48;

        package_name.get_style_context ().add_class ("h3");
        package_name.valign = Gtk.Align.END;
        package_name.xalign = 0;

        info_grid = new Gtk.Grid ();
        info_grid.column_spacing = 12;
        info_grid.row_spacing = 6;
        info_grid.valign = Gtk.Align.START;
        info_grid.attach (image, 0, 0, 1, 2);
        info_grid.attach (package_name, 1, 0, 1, 1);

        action_stack.margin_top = 10;
        action_stack.valign = Gtk.Align.START;

        add (info_grid);
        //add (action_stack, 3, 0, 1, 1);
    }
  }
}
