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

    public string uri { get; construct; }
    public Gdk.Pixbuf thumb { get; construct; }
    public bool active { get; construct; }

    const string CARD_STYLE_CSS = """
        flowboxchild,
        GtkFlowBox .grid-child {
            background-color: #F5F6F7;
        }

        flowboxchild:focus .card,
        GtkFlowBox .grid-child:focus .card {
            border: 1px solid alpha (#000, 0.2);
            border-radius: 3px;
        }
    """;

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
        var provider = new Gtk.CssProvider ();
        try {
            provider.load_from_data (CARD_STYLE_CSS, CARD_STYLE_CSS.length);
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        } catch (Error e) {
            critical (e.message);
        }

         try {
            if(uri != null){
              thumb = new Gdk.Pixbuf.from_resource_at_scale ("/com/github/nick92/Coffee/icons/news/" + uri + ".png", 100 * scale, 100 * scale, false);
            }
        } catch (Error e) {
            critical ("Failed to load wallpaper thumbnail: %s", e.message);
            return;
        }

        image = new Gtk.Image ();
        image.gicon = thumb;
        image.halign = Gtk.Align.CENTER;
        image.valign = Gtk.Align.CENTER;
        image.get_style_context ().set_scale (1);
        // We need an extra grid to not apply a scale == 1 to the "card" style.
        var card_box = new Gtk.Grid ();
        card_box.get_style_context ().add_class ("card");
        card_box.add (image);
        card_box.margin = 9;

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
    }
  }
}
