project ('com.github.nick92.coffee', ['vala', 'c'])

gettext_name = meson.project_name()

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    '-DI_KNOW_THE_PACKAGEKIT_GLIB2_API_IS_SUBJECT_TO_CHANGE',
    language:'c'
)

glib = dependency ('glib-2.0')
gtk = dependency ('gtk+-3.0')
json = dependency ('json-glib-1.0')
soup = dependency ('libsoup-2.4')
webkit = dependency ('webkit2gtk-4.0')
gee = dependency ('gee-0.8')
geocode = dependency('geocode-glib-1.0')
geoclue = dependency('libgeoclue-2.0')

conf_data = configuration_data()

subdir ('data')
subdir ('src')
