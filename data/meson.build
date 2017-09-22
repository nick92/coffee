gnome = import ('gnome')

coffee_resources = gnome.compile_resources ('coffee_resources', 'coffee-resource.xml', source_dir: '.', c_name: 'coffee')

install_data('com.github.nick92.coffee-news.desktop',
    install_dir : join_paths('share', 'applications'))

install_data('com.github.nick92.coffee-news.gschema.xml',
    install_dir : join_paths('share', 'glib-2.0', 'schemas'))

install_data('com.github.nick92.coffee-news.appdata.xml',
    install_dir : join_paths('share', 'metainfo'))

subdir('icons')
