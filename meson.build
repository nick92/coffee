project ('com.github.nick92.coffee', ['vala', 'c'])

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

glib = dependency ('glib-2.0')
gtk = dependency ('gtk+-3.0')
json = dependency ('json-glib-1.0')
soup = dependency ('libsoup-2.4')
webkit = dependency ('webkit2gtk-4.0')
gee = dependency ('gee-0.8')
geocode = dependency('geocode-glib-1.0')
geoclue = dependency('libgeoclue-2.0')
keybinder = dependency('keybinder-3.0')
notify = dependency('libnotify')

meson.add_install_script('data/install_schema.py')

subdir ('data')
subdir ('src')
