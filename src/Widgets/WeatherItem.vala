// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2014-2016 elementary LLC. (https://elementary.io)
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
 * Authored by: Corentin Noël <corentin@elementary.io>
 */
/* Taken from elementary AppCenter */
public class Coffee.Widgets.WeatherItem : Gtk.FlowBoxChild {
    public Coffee.Weather weather { get; construct; }
    private Gtk.Label news_label;
    private Gtk.Label title_label;
    private Gtk.Label description_label;
    private Gtk.Label author_label;
    private Gtk.Grid themed_grid;

    public WeatherItem (Coffee.Weather weather) {
        Object (weather: weather);
    }

    construct {
        var display_image = new Gtk.Image ();

        if(weather.weather_img != null && weather.weather_img != "")
          display_image = load_new_image (weather.weather_img);

        news_label = new Gtk.Label (null);
        news_label.wrap = true;
        news_label.max_width_chars = 25;
        news_label.get_style_context ().add_class ("h1");
        news_label.justify = Gtk.Justification.CENTER;
        news_label.halign = Gtk.Align.FILL;

        news_label.label = weather.day ?? "";

        description_label = new Gtk.Label (null);
        description_label.wrap = true;
        description_label.max_width_chars = 35;
        description_label.get_style_context ().add_class ("h2");
        description_label.justify = Gtk.Justification.CENTER;
        description_label.halign = Gtk.Align.FILL;

        description_label.label = weather.summary ?? "";

        author_label = new Gtk.Label (null);
        author_label.wrap = true;
        author_label.max_width_chars = 15;
        author_label.get_style_context ().add_class ("h3");
        author_label.justify = Gtk.Justification.RIGHT;
        author_label.halign = Gtk.Align.END;

        author_label.label = weather.temp.to_string ();

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 10;
        //grid.column_spacing = 8;
        grid.halign = Gtk.Align.CENTER;
        grid.valign = Gtk.Align.CENTER;
        grid.margin_top = 10;
        grid.margin_end = 10;
        grid.margin_bottom = 10;
        grid.margin_start = 10;

        /*grid.attach (news_label, 0, 0, 2, 1);
        grid.attach (description_label, 0, 1, 1, 1);
        grid.attach (display_image, 1, 1, 1, 1);
        grid.attach (author_label, 0, 2, 2, 1);*/

        grid.add (news_label);
        grid.add (display_image);
        grid.add (description_label);
        grid.add (author_label);

        var expanded_grid = new Gtk.Grid ();
        expanded_grid.expand = true;
        expanded_grid.margin = 12;

        themed_grid = new Gtk.Grid ();
        //themed_grid.get_style_context ().add_class ("category");
        themed_grid.attach (grid, 0, 0, 1, 1);
        themed_grid.attach (expanded_grid, 0, 0, 1, 1);
        themed_grid.margin = 10;

        child = themed_grid;

        /*tooltip_text = app_category.summary ?? ""; */

        show_all ();
    }

    // We need to first download the screenshot locally so that it doesn't freeze the interface.
    private Gtk.Image load_new_image (string url) {
        var image = new Gtk.Image ();
        var ret = GLib.DirUtils.create_with_parents (GLib.Environment.get_tmp_dir () + Path.DIR_SEPARATOR_S + ".coffee", 0755);
        if (ret == -1) {
            critical ("Error creating the temporary folder: GFileError #%d", GLib.FileUtils.error_from_errno (GLib.errno));
        }

        string path = Path.build_path (Path.DIR_SEPARATOR_S, GLib.Environment.get_tmp_dir (), ".coffee", "XXXXXX");
        File fileimage;
        var fd = GLib.FileUtils.mkstemp (path);
        if (fd != -1) {
            var source = File.new_for_uri (url);
            fileimage = File.new_for_path (path);
            try {
                source.copy (fileimage, GLib.FileCopyFlags.OVERWRITE);
            } catch (Error e) {
                debug (e.message);
                return null;
            }

            GLib.FileUtils.close (fd);
        } else {
            critical ("Error create the temporary file: GFileError #%d", GLib.FileUtils.error_from_errno (GLib.errno));
            fileimage = File.new_for_uri (url);
            if (fileimage.query_exists () == false) {
                return null;
            }
        }

        Idle.add (() => {
            try {
                //image.width_request = 80;
                //image.height_request = 50;
                image.icon_name = "image-x-generic";
                image.halign = Gtk.Align.CENTER;
                image.pixbuf = new Gdk.Pixbuf.from_file_at_scale (fileimage.get_path (), 150, 100, true);
                //image.show ();
            } catch (Error e) {
                critical (e.message);
            }

            return GLib.Source.REMOVE;
        });

        return image;
    }
}
