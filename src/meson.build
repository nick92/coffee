
sources = [
    'Main.vala',
    'CoffeeBar.vala',
    'CoffeeView.vala',
    'Post.vala', 		
    'Weather.vala', 				
    'Worker/Retriever.vala',
    'Worker/Parser.vala',
    'Worker/Sources.vala',
    'Settings/SettingsWindow.vala',
    'Settings/Settings.vala',
    'Settings/NewsGrid.vala',
    'Settings/LocationGrid.vala',
    'Settings/NewsContainer.vala',
    'Settings/AboutGrid.vala',
    coffee_resources
]

executable ('com.github.nick92.coffee',
            sources,
            dependencies: [glib, gtk, json, soup, webkit, gee, geocode, geoclue],
            vala_args:['--target-glib=2.38', '--gresources=' + meson.source_root () + '/data/coffee-resource.xml'],
            install: true
            )
