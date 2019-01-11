
sources = [
    'Main.vala',
    'CoffeeBar.vala',
    'Post.vala',
    'Logger.vala',
    'Weather.vala',
    'Views/NewsView.vala',
    'Views/WeatherView.vala',
    'Widgets/MessageDialog.vala',
    'Widgets/NewsFlowBox.vala',
    'Widgets/NewsItem.vala',
    'Widgets/WeatherFlowBox.vala',
    'Widgets/WeatherHeaderFlow.vala',
    'Widgets/WeatherHeaderItem.vala',
    'Widgets/WeatherItem.vala',
    'Widgets/Selector.vala',
    'Worker/Retriever.vala',
    'Worker/Parser.vala',
    'Worker/Sources.vala',
    'Settings/Weather/LocationGrid.vala',
    'Settings/General/AboutGrid.vala',
    'Settings/General/StripeDialog.vala',
    'Settings/News/Dialog/NewsSourcesList.vala',
    'Settings/News/Dialog/NewsSourcesGet.vala',
    'Settings/News/NewsSource.vala',
    'Settings/News/NewsContainer.vala',
    'Settings/News/Dialog/NewsListRow.vala',
    'Settings/News/NewsGrid.vala',
    'Settings/News/Dialog/Sidebar.vala',
    'Settings/SettingsWindow.vala',
    'Settings/Settings.vala',
    coffee_resources
]

config_file = configure_file(
    input: 'config.vala.in',
    output: 'config.vala',
    configuration: conf_data
)

executable (meson.project_name(),
            sources,
            config_file,
            dependencies: [glib, gtk, json, soup, gee, geocode, geoclue],
            vala_args:['--target-glib=2.38', '--gresources=' + meson.source_root () + '/data/coffee-resource.xml'],
            install: true
)
