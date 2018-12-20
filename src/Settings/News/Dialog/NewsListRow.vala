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
    private Gtk.Image image;
    private Gtk.Label package_name;
    private Gtk.Label package_info;
    private NewsSourceGet get_news_source;
    public Gtk.CheckButton checkbox;

    public NewsListRow (NewsSource news_source) {
      Object (news_source : news_source);
    }

    construct {
        //margin = 6;
        margin_start = 12;
        margin_end = 12;

        image = new Gtk.Image ();
        checkbox = new Gtk.CheckButton ();
        package_name = new Gtk.Label (news_source.name ?? "");
        package_info = new Gtk.Label (news_source.description ?? "");
        //get_news_source = new NewsSourceGet ();

        image.icon_size = Gtk.IconSize.DIALOG;
        /* Needed to enforce size on icons from Filesystem/Remote */
        image.pixel_size = 68;

        package_name.get_style_context ().add_class ("h1");
        package_name.valign = Gtk.Align.CENTER;
        package_name.halign = Gtk.Align.START;
        package_name.margin = 5;

        package_info.get_style_context ().add_class ("h3");
        package_info.valign = Gtk.Align.CENTER;
        package_info.halign = Gtk.Align.START;
        package_info.margin = 5;
        package_info.set_line_wrap (true);
        package_info.lines = 2;
        package_info.set_single_line_mode (false);
        package_info.wrap_mode = Pango.WrapMode.WORD_CHAR;
        package_info.set_ellipsize (Pango.EllipsizeMode.END);

        info_grid = new Gtk.Grid ();
        info_grid.column_spacing = 12;
        info_grid.row_spacing = 6;
        info_grid.valign = Gtk.Align.START;
        //info_grid.attach (image, 0, 0, 1, 2);
        info_grid.attach (checkbox, 0, 0, 1, 1);
        info_grid.attach (package_name, 1, 0, 1, 1);
        info_grid.attach (package_info, 1, 1, 1, 1);

        //action_stack.margin_top = 10;
        //action_stack.valign = Gtk.Align.START;

        add (info_grid);
        //add (action_stack, 3, 0, 1, 1);
        //child = info_grid;
    }
  }
}
