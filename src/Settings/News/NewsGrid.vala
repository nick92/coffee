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
  public class News.NewsGrid : Grid {

    private NewsContainer news_sources = null;
    private News.NewsSource news_source;
    private NewsSourceGet news_sources_get;
    private Gtk.FlowBox news_view;
    private NewsContainer news_item;
    public Gtk.Button button_add;
    public Gtk.Button button_refresh;
    public Gtk.Button button_launch;
    private Gtk.Spinner spinner;
    private Gtk.Box button_box;
    private Gtk.ComboBoxText category_combo;
    private Gtk.ComboBoxText country_combo;

    private Settings settings;

    public NewsGrid () {
      settings = Settings.get_default ();
      //this.column_spacing = 10;


      spinner = new Gtk.Spinner ();
      news_sources_get = new NewsSourceGet ();

      button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
      button_box.halign = Gtk.Align.END;
      button_box.spacing = 15;
      button_box.margin_top = 15;

      news_view = new Gtk.FlowBox ();
      news_view.activate_on_single_click = true;
      news_view.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
      news_view.homogeneous = true;
      //wallpaper_view.selection_mode = Gtk.SelectionMode.SINGLE;
      news_view.child_activated.connect (update_checked_news_item);

      category_combo = new Gtk.ComboBoxText ();
      category_combo.margin = 5;
      category_combo.append ("business", _("Business"));
      category_combo.append ("entertainment", _("Entertainment"));
      category_combo.append ("health", _("Health"));
      category_combo.append ("science", _("Science"));
      category_combo.append ("sports", _("Sports"));
      category_combo.append ("technology", _("Technology"));
      category_combo.changed.connect (update_selected_category);
      category_combo.set_active (0);

      country_combo = new Gtk.ComboBoxText ();
      country_combo.margin = 5;
      country_combo.append ("en", _("English"));
      country_combo.append ("de", _("German"));
      country_combo.append ("es", _("Spanish"));
      country_combo.append ("fr", _("French"));
      country_combo.append ("it", _("Italian"));
      country_combo.append ("nl", _("Dutch"));
      country_combo.append ("ru", _("Russian"));
      //ar de en es fr he it nl no pt ru se ud zh
      country_combo.changed.connect (update_selected_category);
      country_combo.set_active (0);

      button_add = new Gtk.Button ();
      button_add.image = new Gtk.Image.from_icon_name  ("list-add-symbolic", Gtk.IconSize.MENU);
      if(settings.first_load_bool)
        button_add.label = "Add News Source";
      button_add.halign = Gtk.Align.END;
      button_add.set_tooltip_text ("Add News");
      button_add.margin_top = 15;
      if(settings.first_load_bool)
        button_add.margin_end = 145;
      //button_add.set_relief(Gtk.ReliefStyle.NONE);
      button_add.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

      button_refresh = new Gtk.Button ();
      button_refresh.image = new Gtk.Image.from_icon_name  ("view-refresh-symbolic", Gtk.IconSize.MENU);
      //button_add.label = "Add News Source";
      button_refresh.halign = Gtk.Align.END;
      button_refresh.set_tooltip_text ("Refresh News");
      //button_refresh.margin_top = 15;
      //button_refresh.margin_end = 45;
      //button_add.set_relief(Gtk.ReliefStyle.NONE);
      button_refresh.get_style_context ().add_class (Gtk.STYLE_CLASS_INFO);

      button_launch = new Gtk.Button ();
      button_launch.image = new Gtk.Image.from_icon_name  ("object-select-symbolic", Gtk.IconSize.MENU);
      button_launch.label = "Launch Coffee";
      button_launch.halign = Gtk.Align.END;
      button_launch.set_tooltip_text ("Check at least one news item to continue");
      button_launch.margin_top = 15;
      //button_launch.margin_start = 45;
      button_launch.sensitive = false;
      //button_add.set_relief(Gtk.ReliefStyle.NONE);
      button_launch.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

      var scrolled = new Gtk.ScrolledWindow (null, null);
      scrolled.expand = true;
      //scrolled.min_content_height = 400;
      scrolled.add (news_view);

      news_source = NewsSource.get_default ();

      load_new_sources ();

			news_source.get_sources_completed.connect (() => {
        warning("complete");
        spinner.active = false;
        news_view.show_all ();
			});

			news_source.new_source.connect ((source) => {
        news_item = new NewsContainer (source);
        news_view.add (news_item);
        //news_item.show ();
      });
      
      button_box.add (country_combo);
      button_box.add (category_combo);
      button_box.add (spinner);

      //news_item.show_all ();
      //scrolled.add (button_add);
      if(settings.first_load_bool){
        //this.attach(button_add, 0, 1, 1, 1);
        button_box.add(button_launch);
      }
      else{
        button_box.add(button_refresh);
        //this.attach(button_add, 0, 1, 1, 1);
      }
      this.attach(scrolled, 0, 0, 1, 1);
      this.attach(button_box, 0, 1, 1, 1);

      //connect_events();
      this.show_all();
    }

    private void update_checked_news_item (Gtk.FlowBox box, Gtk.FlowBoxChild child) {
        var children = (NewsContainer) news_view.get_selected_children ().data;

        if(children.checked)
          children.checked = false;
        else
          children.checked = true;

        button_launch.sensitive = true;

        settings.set_news_enabled(children.checked, children.news_source.id);

        news_sources = children;
    }

    private void update_selected_category () {
      //new Thread<void*> ("get_news_sources", () => {
				spinner.active = true;
        //remove_rows ();
        refresh_list();
				news_sources_get.get_sources (category_combo.get_active_id (), country_combo.get_active_id ());
				//return null;
			//});
    }

    private void load_new_sources () {
      new Thread<void*> ("get_news_sources", () => {
				spinner.active = true;
        //remove_rows ();
        refresh_list();
				news_sources_get.get_sources ("business", "en");
				return null;
			});

    }


    public void refresh_news_items (){
      refresh_list();
      //foreach (string source in settings.get_news_sources()) {
        //news_item = new NewsContainer (source, settings.get_news_source_bool (source));
        //news_view.add (news_item);
      //}
      this.show_all();
    }

    private void refresh_list () {
      foreach(Widget child in news_view.get_children ()) {
        news_view.remove(child);
      }
    }
  }
}
