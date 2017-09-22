sizes = ['16x16', '32x32', '48x48' , '64x64', '128x128', '512x512']
themedir = get_option('datadir') + '/icons/hicolor/'

foreach size: sizes
    install_data(size + '/coffee-news.svg', install_dir: themedir + size + '/apps/')
endforeach
