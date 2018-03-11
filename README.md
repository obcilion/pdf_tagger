To get up and running

* Install ruby version 2.5
* Install bundler with `gem install bundler`
* Run `bundle install` in project directory

Run tagger.rb with file directory as argument

E.g. `ruby tagger.rb ~/Documents/all_my_pdfs`

Program wil add [text] to the beginning of the filename of pdfs containing any text, and [image] to all others
When finished, the program will create two files, `image_files.txt` and `text_files.txt`, each containing a list of files