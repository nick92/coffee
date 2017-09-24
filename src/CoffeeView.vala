/*
 * Main.vala
 * This file is part of Coffee
 *
 * Copyright (C) 2017 - Nick Wilkins
 *
 * Coffee is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * news is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Coffee. If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using WebKit;

namespace Coffee {
  public class CoffeeView : WebView {

    private Post _post = null;
    private Weather _weather = null;
    private Forecast _forecast = null;
    private string article_html = " ";
    private string news_html;
    private string style_css;
    private string loading_html;
    private CoffeeApp app = null;
    private StringBuilder forecast_str = null;
    private string weather_html = " ";

    private Settings.Settings coffee_settings;

    private string HIDE_NEWS_CSS = """
      news-container {
        display: none;
      }
      """;

    private string HIDE_WEATHER_CSS = """
      weather-container {
        display: none;
      }
      """;

    public CoffeeView (){
      Object (name: "Article");
      //this.zoom_level = 1.6;
      app = GLib.Application.get_default () as CoffeeApp;
      coffee_settings = Settings.Settings.get_default ();
      try {
          news_html = app.load_from_resource ("/com/github/nick92/Coffee/ui/News.html");
          style_css = load_css();
          loading_html = app.load_from_resource ("/com/github/nick92/Coffee/ui/Loading.html");

          forecast_str = new StringBuilder();

      } catch (Error e) {
          critical (e.message);
      }
    }

    public Post post {
      get {
        return _post;
      }
      set {
          _post = value;
          string html = " ";
          try {
              html = app.load_from_resource ("/com/github/nick92/Coffee/ui/Article.html")
                  .printf (_post.link ?? "", _post.title ?? "",_post.image_link ?? "",_post.subject ?? "",_post.author ?? "");
          } catch (Error e) {
              critical (e.message);
          }
          add_article(html);
      }
    }

    public Forecast forecast {
      get {
        return _forecast;
      }
      set {
          _forecast = value;
          string html = " ";
          try {
              html = app.load_from_resource ("/com/github/nick92/Coffee/ui/Forecast.html")
                  .printf (_forecast.day,_forecast.weather_img ?? "",_forecast.temp);
          } catch (Error e) {
              critical (e.message);
          }
          forecast_str.append(html);
      }
    }

    public Weather weather {
      get {
        return _weather;
      }
      set {
          _weather = value;
          string html = " ";
          try {
              html = app.load_from_resource ("/com/github/nick92/Coffee/ui/Weather.html")
                  .printf (_weather.link ?? "", _weather.location ?? "",_weather.weather_img ?? "",_weather.temp,_weather.text ?? "",_weather.summary ?? "", forecast_str.str.dup ());
          } catch (Error e) {
              critical (e.message);
          }
          weather_html = html;
      }
    }


    private void add_article (string new_article_html)
    {
      article_html = article_html +  new_article_html;
    }

    public void reload_articles(){
      forecast_str = new StringBuilder();
      weather_html = " ";
      article_html = " ";
      try{
        news_html = app.load_from_resource ("/com/github/nick92/Coffee/ui/News.html");
      } catch (Error e) {
          critical (e.message);
      }
    }

    public void loading_page ()
    {
      load_html(loading_html, null);
    }

    private string load_css ()
    {
      string css_string = "";
      try {
        if(!coffee_settings.news_bool && !coffee_settings.weather_bool)
          css_string = app.load_css_from_resource ("/com/github/nick92/Coffee/ui/style.css", HIDE_NEWS_CSS + HIDE_WEATHER_CSS);
        else if(!coffee_settings.news_bool)
          css_string = app.load_css_from_resource ("/com/github/nick92/Coffee/ui/style.css", HIDE_NEWS_CSS);
        else if(!coffee_settings.weather_bool)
          css_string = app.load_css_from_resource ("/com/github/nick92/Coffee/ui/style.css", HIDE_WEATHER_CSS);
        else
          css_string = app.load_css_from_resource ("/com/github/nick92/Coffee/ui/style.css", "");
      } catch (Error e) {
          critical (e.message);
      }
      return css_string;
    }

    public void load_new_html ()
    {
      this.reload ();
      news_html = news_html.printf(load_css(), weather_html, article_html);
      load_html(news_html, null);
    }
  }
}
