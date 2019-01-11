/*-
 * Copyright (c) 2015-2017 elementary LLC. (https://bugs.launchpad.net/switchboard-plug-pantheon-shell)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Erasmo Marín
 *
 */
namespace Settings {
  public class News.NewsContainer : Gtk.FlowBoxChild {
    private Gtk.Revealer check_revealer;
    private Gtk.Image image;
    private Gtk.Label name;

    public string uri { get; construct; }
    public string icon { get; construct; }
    public Gdk.Pixbuf thumb { get; construct; }
    public Gtk.Image img_thumb;
    public bool active { get; construct; }

    public bool checked {
        get {
            return Gtk.StateFlags.CHECKED in image.get_state_flags ();
        } set {
            if (value) {
                image.set_state_flags (Gtk.StateFlags.CHECKED, false);
                check_revealer.reveal_child = true;
            } else {
                image.unset_state_flags (Gtk.StateFlags.CHECKED);
                check_revealer.reveal_child = false;
            }

            queue_draw ();
        }
    }

    public bool selected {
        get {
            return Gtk.StateFlags.SELECTED in get_state_flags ();
        } set {
            if (value) {
                set_state_flags (Gtk.StateFlags.SELECTED, false);
            } else {
                unset_state_flags (Gtk.StateFlags.SELECTED);
            }

            queue_draw ();
        }
    }

    public NewsContainer (string uri, bool active) {
        Object (uri: uri, active: active);
    }

    construct {
        var scale = get_style_context ().get_scale ();

         try {
            if(uri != null){
              thumb = load_new_image (uri);
            }
        } catch (Error e) {
            //critical ("Failed to load wallpaper thumbnail: %s", e.message);
            thumb = new Gdk.Pixbuf.from_resource_at_scale ("/com/github/nick92/Coffee/icons/news/question.png", 100 * scale, 100 * scale, false);
            //return;
        }

        var uri_name = uri.replace ("-"," ");

        name = new Gtk.Label (uri_name);

        image = new Gtk.Image ();
        image.gicon = thumb;
        image.halign = Gtk.Align.CENTER;
        image.valign = Gtk.Align.CENTER;
        image.get_style_context ().set_scale (1);
        // We need an extra grid to not apply a scale == 1 to the "card" style.
        var card_box = new Gtk.Grid ();
        card_box.get_style_context ().add_class ("card");
        
        card_box.attach (image, 0, 0, 1, 1);
        card_box.attach (name, 0, 1, 1, 1);
        card_box.margin = 15;
        card_box.set_row_spacing (10);

        //var check = new Gtk.Image.from_icon_name ("selection-checked", Gtk.IconSize.LARGE_TOOLBAR);
        var check = new Gtk.Image.from_resource  ("/com/github/nick92/Coffee/icons/symbol/selection-check.svg");
        check.halign = Gtk.Align.START;
        check.valign = Gtk.Align.START;

        check_revealer = new Gtk.Revealer ();
        check_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
        check_revealer.add (check);

        var overlay = new Gtk.Overlay ();
        overlay.add (card_box);
        overlay.add_overlay (check_revealer);

        halign = Gtk.Align.CENTER;
        valign = Gtk.Align.CENTER;
        height_request = thumb.get_height () / scale + 18;
        width_request = thumb.get_width () / scale + 18;
        margin = 6;
        add (overlay);

        if(active)
          checked = true;
        else
          checked = false;

        activate.connect (() => {
            if(active)
              checked = true;
            else
              checked = false;
        });

        card_box.query_tooltip.connect ((x, y, keyboard_tooltip, tooltip) => {
			//tooltip.set_icon_from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR); 
			tooltip.set_markup ("<b>My Tooltip</b>");
			return true;
		});
    }

    // We need to first download the screenshot locally so that it doesn't freeze the interface.
    private Gdk.Pixbuf load_new_image (string url) {
        debug("Getting icon from Besticon:%s", url);
        //var image = new Gdk.Pixbuf ();
        Gdk.Pixbuf image = null;
        var ret = GLib.DirUtils.create_with_parents (GLib.Environment.get_user_cache_dir () + Path.DIR_SEPARATOR_S + "com.github.nick92.coffee" + Path.DIR_SEPARATOR_S + "news_icons", 0755);
        if (ret == -1) {
            critical ("Error creating the temporary folder: GFileError #%d", GLib.FileUtils.error_from_errno (GLib.errno));
        }
        string path = Path.build_path (Path.DIR_SEPARATOR_S, GLib.Environment.get_user_cache_dir (), "com.github.nick92.coffee", "news_icons");
        File fileimage;
        //var source = File.new_for_uri (url);
        fileimage = File.new_for_path (path  + Path.DIR_SEPARATOR_S + url);

        try {
            if(fileimage.query_exists ()){
              image = new Gdk.Pixbuf.from_file_at_scale (fileimage.get_path (), 160, 100, true);
            }
            else {
                NewsSourceGet news_sources_get = new NewsSourceGet ();
                news_sources_get.get_besticon_url (url, (obj, res) => {
                    var besticon_url = news_sources_get.get_besticon_url.end (res);
                    if(fileimage.query_exists ()){
                        image = new Gdk.Pixbuf.from_file_at_scale (fileimage.get_path (), 160, 100, true);
                    }                        
                });
                image = new Gdk.Pixbuf.from_resource_at_scale ("/com/github/nick92/Coffee/icons/news/question.png", 160, 100, true);
            }

        } catch (Error e) {
            debug (e.message);
            return null;
        }

        return image;
    }
  }
}
