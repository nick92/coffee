/*
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
using Geocode;

namespace Settings {
  public class NewsGrid : Grid {

    private Gtk.Switch _switch_google_news;
    private Gtk.Switch _switch_bbc_news;
    private Gtk.Switch _switch_bbc_sport;
    private NewsContainer news_sources = null;
    private Gtk.FlowBox wallpaper_view;
    private NewsContainer news_item;

    private Settings settings;

    public NewsGrid () {
      settings = Settings.get_default ();
      _switch_google_news = new Gtk.Switch ();
      _switch_bbc_sport = new Gtk.Switch ();
      _switch_bbc_news = new Gtk.Switch ();

      if(settings.bbc_news_bool)
        _switch_bbc_news.active = true;
      if(settings.google_news_bool)
        _switch_google_news.active = true;
      if(settings.bbc_sport_bool)
        _switch_bbc_sport.active = true;

      wallpaper_view = new Gtk.FlowBox ();
      wallpaper_view.activate_on_single_click = true;
      wallpaper_view.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
      wallpaper_view.homogeneous = true;
      //wallpaper_view.selection_mode = Gtk.SelectionMode.SINGLE;
      wallpaper_view.child_activated.connect (update_checked_wallpaper);

      var scrolled = new Gtk.ScrolledWindow (null, null);
      scrolled.expand = true;
      scrolled.add (wallpaper_view);

      foreach (string source in settings.get_news_sources()) {
        news_item = new NewsContainer (source, settings.get_news_source_bool (source));
        wallpaper_view.add (news_item);
      }

      news_item.show_all ();
      this.attach(scrolled, 1, 0, 1, 1);
      connect_events();
    }

    private void update_checked_wallpaper (Gtk.FlowBox box, Gtk.FlowBoxChild child) {
        var children = (NewsContainer) wallpaper_view.get_selected_children ().data;

        if(children.checked)
          children.checked = false;
        else
          children.checked = true;

        settings.change_setting_bool(children.checked, children.uri);

        news_sources = children;
    }

    private void connect_events (){

      _switch_google_news.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_google_news.active, settings.google_news_string);
      });

      _switch_bbc_news.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_bbc_news.active, settings.bbc_news_string);
      });

      _switch_bbc_sport.notify["active"].connect (() => {
        settings.change_setting_bool(_switch_bbc_sport.active, settings.bbc_sport_string);
      });

    }
  }
}
