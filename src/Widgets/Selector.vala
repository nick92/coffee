/*
 * CoffeeBar.vala
 * This file is part of Coffee
 *
 * Copyright (C) 2017 - Nick Wilkins
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

public enum Coffee.Widgets.Modality {
    NEWS_VIEW = 0,
    WEATHER_VIEW = 1
}

public class Coffee.Widgets.Selector : Gtk.ButtonBox {

    public signal void mode_changed();

    private int _selected;
    public int selected {
        get {
            return this._selected;
        }
        set {
            this.set_selector(value);
        }
    }

    //private Gtk.ToggleButton view_all;
    private Gtk.ToggleButton view_news;
    private Gtk.ToggleButton view_weather;

    public Selector(Gtk.Orientation orientation) {

        this._selected = -1;
        this.set_orientation(orientation);
        this.set_layout(Gtk.ButtonBoxStyle.CENTER);
        this.margin_top = 10;
        this.margin_bottom = 10;

        view_news = new Gtk.ToggleButton();
        view_news.set_relief(Gtk.ReliefStyle.NONE);
        var image = new Gtk.Image.from_icon_name ("x-office-document-symbolic", Gtk.IconSize.MENU);
        image.tooltip_text = _("News View");

        view_news.add(image);
        this.pack_start (view_news,false,false,0);

        view_weather = new Gtk.ToggleButton();
        var stared_image = new Gtk.Image.from_icon_name ("weather-few-clouds-symbolic", Gtk.IconSize.MENU);
        stared_image.tooltip_text = _("Weather View");
        view_weather.set_relief(Gtk.ReliefStyle.NONE);
        view_weather.add(stared_image);
        this.pack_start(view_weather,false,false,0);

        view_news.button_release_event.connect( (bt) => {
            this.set_selector(0);
            return true;
        });
        view_weather.button_release_event.connect( (bt) => {
            this.set_selector(1);
            return true;
        });
    }

    public int get_selector() {
        return this._selected;
    }

    public void set_selector(int v) {
        if (this._selected != v) {
            this._selected = v;
            switch(v) {
            case 0:
                this.view_news.set_active(true);
                this.view_weather.set_active(false);
                break;
            case 1:
                this.view_weather.set_active(true);
                this.view_news.set_active(false);
                break;
            }

            this.mode_changed();
        }
    }
}
