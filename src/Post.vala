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

namespace Coffee {
  public class Post : Object {

    private Gee.ArrayList<Post> posts = null;

    static Post? instance = null;

    public string title { get; set; }
    public string image_link { get; set; }
    public string subject { get; set; }
    public string author { get; set; }
    public string link { get; set; }

    public signal void post_added ();
    public signal void post_add_completed ();

    public Post () {
      posts = new Gee.ArrayList<Post>();
    }

    public static Post get_default () {
      if (instance == null) {
          instance = new Post ();
      }

      return instance;
    }

    public void add_post (Post post)
    {
      posts.add(post);
      post_added ();
    }

    public void clear_posts ()
    {
      posts.clear();
    }

    public void parse_completed ()
    {
      post_add_completed();
    }

    public Gee.ArrayList<Post> get_posts () {
      if(posts == null){
        return new Gee.ArrayList<Post>();
      }

      return posts;
    }

    public int get_count () {
      return posts.size;
    }
  }
}
