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
	public class News.NewsSourcesList : Window {

		private Gtk.Box box;
		private Gtk.SearchEntry news_search_entry;
		private Gtk.TreeView view;
		private Gtk.TreeStore list_store;
		private Settings settings;
		private Sidebar sidebar;
		private Gtk.Button button_add_news;

		private Gtk.ListBox list_box;
		private Gtk.ListBoxRow list_box_row;
		private Gtk.Spinner spinner;

		private NewsSource news_source;
		private NewsSourceGet news_sources_get;

		private Gtk.Grid container;
		private Gtk.Separator separator;

		public signal void news_added ();

		protected void add_row (NewsSource news_row) {
			var row = new NewsListRow (news_row);
			list_box.add (row);
					row.show_all ();
			//row.get_package ().changing.connect (on_package_changing);
		}

		private void remove_rows () {
			//news_source.clear ();
			if(list_box.get_children ().length().to_string().to_int() > 0){
				list_box.get_children ().foreach ((child) => {
						list_box.remove (child);
						list_box.queue_resize ();
				});
			}
		}

		public NewsSourcesList (Window settings_window) {
			this.set_transient_for (settings_window);
			this.destroy_with_parent = true;
			this.title = "News Sources";

      		// Sets the default size of a window:
    		this.set_default_size (800, 550);
        	this.window_position = Gtk.WindowPosition.CENTER;

    		settings = Settings.get_default ();

    		var scrolled = new Gtk.ScrolledWindow (null, null);
    		scrolled.expand = true;
			sidebar = new Sidebar ();

			container = new Gtk.Grid ();
			container.hexpand = true;
			container.row_homogeneous = false;
			container.column_homogeneous = false;
			container.orientation = Gtk.Orientation.HORIZONTAL;
			separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);

			box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
			//box.margin = 5;

			button_add_news = new Gtk.Button();
			button_add_news.label = "Done";
			button_add_news.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
			button_add_news.margin = 5;

			button_add_news.clicked.connect(() => {
				//list_box.get_selected_rows ().foreach ((r) => {	
				/* list_box.get_children ().foreach ((r) => {
					var row = (NewsListRow)r;
					if(row.checkbox.active) {
						news_sources_get.get_besticon_url (row.news_source.url, (obj, res) => {
						var besticon_url = news_sources_get.get_besticon_url.end (res);
							load_new_image (besticon_url, row.news_source.id);
							settings.set_news_source (row.news_source.id);
							news_added();
						});
					}
				});*/
				this.destroy();
			});

			news_search_entry = new Gtk.SearchEntry ();
			spinner = new Gtk.Spinner ();

			list_box = new Gtk.ListBox ();
			list_box.expand = true;
			list_box.activate_on_single_click = true;
			list_box.row_activated.connect ((r) => {
				var row = (NewsListRow)r;
				row.checkbox.set_active(!row.checkbox.active);
				news_sources_get.get_besticon_url (row.news_source.url, (obj, res) => {
					var besticon_url = news_sources_get.get_besticon_url.end (res);
					load_new_image (besticon_url, row.news_source.id);
					settings.set_news_source (row.news_source.id);
					news_added();
				});
			});

			news_search_entry.search_changed.connect (() => {
				//warning (news_search_entry.get_text ());
			});

			news_source = NewsSource.get_default ();

			news_source.get_sources_completed.connect (() => {
				news_source.clear ();
				spinner.active = false;
				if(news_source.get_count() < 5)
				{
					//var dummysource = new NewsSource();

					//add_row (new NewsSource ());
				}
			});

			news_source.new_source.connect ((source) => {
				add_row (source);
			});

			sidebar.add_category ("General");
			sidebar.add_category ("Sports");
			sidebar.add_category ("Entertainment");
			sidebar.add_category ("Business");
			sidebar.add_category ("Health");
			sidebar.add_category ("Science");
			sidebar.add_category ("Technology");

			sidebar.selection_changed.connect ((name, nth) => {
				selection_changed (name);
			});

			//box.add(spinner);
			//box.add(list_box);

			//box.pack_start (spinner, true, false, 0);
			//box.pack_start (news_search_entry, true, false, 0);
			box.pack_start (list_box, true, false, 0);

			scrolled.add(box);

			container.attach (sidebar, 0, 0, 1, 1);
        	container.attach (scrolled, 1, 0, 1, 1);
			container.attach (spinner, 0, 1, 1, 1);
			container.attach (button_add_news, 1, 1, 1, 1);
        	add (container);

			//add(scrolled);
		}

		private void selection_changed (string name)
		{
			//new Thread<void*> ("get_news_sources", () => {
				spinner.active = true;
				remove_rows ();
				news_sources_get = new NewsSourceGet ();
				news_sources_get.get_sources (name);
				//news_source.clear ();
				//return null;
			//});
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

		// We need to first download the screenshot locally so that it doesn't freeze the interface.
		public void load_new_image (string url, string icon) {
			debug("Getting icon from Besticon:url:%s:icon:%s", url, icon);
			var ret = GLib.DirUtils.create_with_parents (GLib.Environment.get_user_cache_dir () + Path.DIR_SEPARATOR_S + "com.github.nick92.coffee" + Path.DIR_SEPARATOR_S + "news_icons", 0755);
			if (ret == -1) {
				critical ("Error creating the temporary folder: GFileError #%d", GLib.FileUtils.error_from_errno (GLib.errno));
			}

			string path = Path.build_path (Path.DIR_SEPARATOR_S, GLib.Environment.get_user_cache_dir (), "com.github.nick92.coffee", "news_icons");
			File fileimage;
			var source = File.new_for_uri (url);
			fileimage = File.new_for_path (path  + Path.DIR_SEPARATOR_S + icon);
			try {
				if(!fileimage.query_exists ()){
					source.copy (fileimage, GLib.FileCopyFlags.OVERWRITE);
				}
			} catch (Error e) {
				debug (e.message);
				//return null;
			}

			/*Idle.add (() => {
				try {
					//image.width_request = 80;
					//image.height_request = 50;
					//image.icon_name = "image-x-generic";
					//image.halign = Gtk.Align.CENTER;
					//image = new Gdk.Pixbuf.from_file_at_scale (fileimage.get_path (), 160, 100, true);
					//image.show ();
				} catch (Error e) {
					critical (e.message);
				}

				return GLib.Source.REMOVE;
			});*/

			//return image;
		}
	}
}
