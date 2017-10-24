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

    private NewsContainer news_sources = null;
    private Gtk.FlowBox news_view;
    private NewsContainer news_item;

    private Settings settings;

    public NewsGrid () {
      settings = Settings.get_default ();

      news_view = new Gtk.FlowBox ();
      news_view.activate_on_single_click = true;
      news_view.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
      news_view.homogeneous = true;
      //wallpaper_view.selection_mode = Gtk.SelectionMode.SINGLE;
      news_view.child_activated.connect (update_checked_wallpaper);

      var scrolled = new Gtk.ScrolledWindow (null, null);
      scrolled.expand = true;
      //scrolled.min_content_height = 400;
      scrolled.add (news_view);

      foreach (string source in settings.get_news_sources()) {
        news_item = new NewsContainer (source, settings.get_news_source_bool (source));
        news_view.add (news_item);
      }

      //news_item.show_all ();
      this.attach(scrolled, 1, 0, 1, 1);
      //connect_events();
      this.show_all();
    }

    private void update_checked_wallpaper (Gtk.FlowBox box, Gtk.FlowBoxChild child) {
        var children = (NewsContainer) news_view.get_selected_children ().data;

        if(children.checked)
          children.checked = false;
        else
          children.checked = true;

        settings.set_news_enabled(children.checked, children.uri);

        news_sources = children;
    }

    public void refresh_news_items (){
      refresh_list();
      foreach (string source in settings.get_news_sources()) {
        news_item = new NewsContainer (source, settings.get_news_source_bool (source));
        news_view.add (news_item);
      }
      this.show_all();
    }

    private void refresh_list () {
      foreach(Widget child in news_view.get_children ())
      {
        news_view.remove(child);
      }
    }
  }
}
