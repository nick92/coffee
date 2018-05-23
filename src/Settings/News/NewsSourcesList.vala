/* * Copyright (C) 2017 - Nick Wilkins * * Coffee is free software; you can
redistribute it and/or modify * it under the terms of the GNU General Public
License as published by * the Free Software Foundation; either version 2 of
the License, or * (at your option) any later version. * * Coffee is
distributed in the hope that it will be useful, * but WITHOUT ANY WARRANTY;
without even the implied warranty of * MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the * GNU General Public License for more details. *
* You should have received a copy of the GNU General Public License * along
with Coffee. If not, see <http://www.gnu.org/licenses/>. */

using Gtk;

namespace Settings {
	public class NewsSourcesList : Window {

		private Gtk.Box box;
		private Gtk.SearchEntry news_search_entry;
		private Gtk.TreeView view;
		private Gtk.TreeStore list_store;
		private Settings settings;

		private Gtk.ListBox list_box;
		private Gtk.ListBoxRow list_box_row;

		private NewsSource news_source;
		private NewsSourceGet get_news_sources;

		public signal void news_added ();

		const string TREE_VIEW_CSS = """
        flowboxchild,
        GtkTreeView {
            font-size: 12px;
            padding-top: 2px;
            padding-bottom: 2px;
        }
    """;

		protected void add_row (NewsSource news_row) {
			var row = new Gtk.ListBoxRow ();

      row.show_all ();
      list_box.add (row);
      //row.get_package ().changing.connect (on_package_changing);
    }

		public NewsSourcesList () {
				this.title = "News Sources";

      	// Sets the default size of a window:
    		this.set_default_size (600, 500);

    		settings = Settings.get_default ();

    		var scrolled = new Gtk.ScrolledWindow (null, null);
    		scrolled.expand = true;

    		var provider = new Gtk.CssProvider ();
	        try {
	            provider.load_from_data (TREE_VIEW_CSS, TREE_VIEW_CSS.length);
	            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
	        } catch (Error e) {
	            critical (e.message);
	        }

    			if (box == null) {
	            box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
	            //grid.margin = 12;

	            news_search_entry = new Gtk.SearchEntry ();

							list_box = new Gtk.ListBox ();
	            list_box.expand = true;
	            list_box.activate_on_single_click = true;
	            //list_box.set_placeholder (alert_view);
	            list_box.set_selection_mode (Gtk.SelectionMode.NONE);
	            //list_box.set_sort_func ((Gtk.ListBoxSortFunc) package_row_compare);
	            list_box.row_activated.connect ((r) => {
	                //var row = (Widgets.AppListRow)r;
	                //show_app (row.get_package ());
	            });
							news_source = NewsSource.get_default ();

							new Thread<void*> ("get_news_sources", () => {
								get_news_sources = new NewsSourceGet ();

								return null;
							});

	            // The Model:
	            try{
								/*list_store = new Gtk.TreeStore (3, typeof (string), typeof (string), typeof (Gdk.Pixbuf));
								Gtk.TreeIter iter;
								Gtk.TreeIter general_iter;
								Gtk.TreeIter technology_iter;
								Gtk.TreeIter entertainment_iter;
								Gtk.TreeIter business_iter;
								Gtk.TreeIter sport_iter;
								Gtk.TreeIter politics_iter;

								//musicListStore.AppendValues (new Gdk.Pixbuf.from_resource ("/com/github/nick92/Coffee/icons/news/cnn.png"), "Rupert");
								list_store.append (out general_iter, null);
								list_store.set (general_iter, 1, "General", -1);
								list_store.append (out technology_iter, null);
								list_store.set (technology_iter, 1, "Technology", -1);
								list_store.append (out entertainment_iter, null);
								list_store.set (entertainment_iter, 1, "Entertainment", -1);
								list_store.append (out business_iter, null);
								list_store.set (business_iter, 1, "Business", -1);
								list_store.append (out politics_iter, null);
								list_store.set (politics_iter, 1, "Politics", -1);
								list_store.append (out sport_iter, null);
								list_store.set (sport_iter, 1, "Sports", -1);

								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "abc-news-au", 1, "ABC News (AU)", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/abc-news-au.png", 100, 100, false), -1);
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "al-jazeera-english", 1, "Al Jazeera", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/al-jazeera-english.png", 100, 100, false), -1);
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "ars-technica", 1, "Ars Technica", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/ars-technica.png", 100, 100, false), -1);
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "associated-press", 1, "Associated Press", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/associated-press.png", 100, 100, false), -1);
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "bbc-news", 1, "BBC News", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/bbc-news.png", 100, 100, false), -1);
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "bbc-sport", 1, "BBC Sport", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/bbc-sport.png", 100, 100, false), -1);
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "bild", 1, "Bild", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/bild.png", 100, 100, false), -1);
								list_store.append (out iter, business_iter);
								list_store.set (iter, 0, "bloomberg", 1, "Bloomberg", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/bloomberg.png", 100, 100, false));
								list_store.append (out iter, politics_iter);
								list_store.set (iter, 0, "breibart-news", 1, "Breibart News", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/breibart-news.png", 100, 100, false));
								list_store.append (out iter, business_iter);
								list_store.set (iter, 0, "business-insider", 1, "Business Insider", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/business-insider.png", 100, 100, false));
								list_store.append (out iter, entertainment_iter);
								list_store.set (iter, 0, "buzzfeed", 1, "Buzzfeed", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/buzzfeed.png", 100, 100, false));
								list_store.append (out iter, business_iter);
								list_store.set (iter, 0, "cnbc", 1, "CNBC", 2,  new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/cnbc.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "cnn", 1, "CNN", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/cnn.png", 100, 100, false));
								list_store.append (out iter, entertainment_iter);
								list_store.set (iter, 0, "entertainment-weekly", 1, "Entertainment Weekly", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/entertainment-weekly.png", 100, 100, false));
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "espn", 1, "ESPN", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/espn.png", 100, 100, false));
								list_store.append (out iter, business_iter);
								list_store.set (iter, 0, "financial-times", 1, "Financial Times", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/financial-times.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "focus", 1, "Focus", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/focus.png", 100, 100, false));
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "football-italia", 1, "Football Italia (IT)", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/football-italia.png", 100, 100, false));
								list_store.append (out iter, business_iter);
								list_store.set (iter, 0, "fortune", 1, "Fortune", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/fortune.png", 100, 100, false));
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "four-four-two", 1, "Four Four Two", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/four-four-two.png", 100, 100, false));
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "fox-sport", 1, "Fox Sport", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/fox-sport.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "google-news", 1, "Google News", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/google-news.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "hacker-news", 1, "Hacker News", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/hacker-news.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "ign", 1, "IGN", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/ign.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "independent", 1, "The Independent", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/independent.png", 100, 100, false));
								list_store.append (out iter, entertainment_iter);
								list_store.set (iter, 0, "mashable", 1, "Mashable", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/mashable.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "metro", 1, "Metro", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/metro.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "new-scientist", 1, "New Scientist", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/new-scientist.png", 100, 100, false));
								list_store.append (out iter, sport_iter);
								list_store.set (iter, 0, "nfl-news", 1, "NFL News", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/nfl-news.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "polygon", 1, "Polygon", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/polygon.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "recode", 1, "Recode", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/recode.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "reddit-r-all", 1, "Reddit-r-all", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/reddit-r-all.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-guardian-uk", 1, "The Guardian (UK)", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-guardian-uk.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-lad-bible", 1, "The Lad Bible", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-lad-bible.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-new-york-times", 1, "The New York Times", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-new-york-times.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "the-next-web", 1, "The Next Web", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-next-web.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-telegraph", 1, "The Telegraph", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-telegraph.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-times-of-india", 1, "The Times of India", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-times-of-india.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "the-verge", 1, "The Verge", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-verge.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "the-washington-post", 1, "The Washington Port", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/the-washington-post.png", 100, 100, false));
								list_store.append (out iter, general_iter);
								list_store.set (iter, 0, "time", 1, "Time", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/time.png", 100, 100, false));
								list_store.append (out iter, technology_iter);
								list_store.set (iter, 0, "wired-de", 1, "Wired (DE)", 2, new Gdk.Pixbuf.from_resource_at_scale("/com/github/nick92/Coffee/icons/news/wired-de.png", 100, 100, false));

								// The View:
								view = new Gtk.TreeView.with_model (list_store);
								view.show_expanders = true;
								view.row_activated.connect(news_row_activated);
					            //box.pack_start (news_search_entry, false, true, 0);
					            //box.pack_start (view, false, true, 0);

					            //Gtk.CellRendererText cell = new Gtk.CellRendererText ();
								view.insert_column_with_attributes (-1, "Sources", new Gtk.CellRendererText (), "text", 1);
								view.insert_column_with_attributes (-1, "", new Gtk.CellRendererPixbuf (), "pixbuf", 2);*/
						}catch (Error e) {
		            critical ("Failed to load wallpaper thumbnail: %s", e.message);
		        }

		        scrolled.add(view);
			}
			add(scrolled);
		}

		private void news_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column)
		{
			Gtk.TreeIter iter;
			Value val;

			list_store.get_iter (out iter, path);
			list_store.get_value (iter, 0, out val);
			settings.set_news_source((string) val);

			news_added();
		}
	}
}
