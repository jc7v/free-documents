# Issues

## 15. Simplify the interface for filtering by tags with a SolR search

* wouldo

For now, there is one button for full text search and one button for filtering. Only one 
button for the both would be better. Needs a bit of changing the interface and code refactoring

## 14. Order by title and updated when searching with SolR

* mustdo

-> 1.0

Need to check the solr doc

## 4. ~~Extracting information from PDF lead sometimes to encoding problems~~

* high
* bug

## 5. ~~Double navbar when an admin and an user logged in on the same session~~

* high
* bug

-> 1.0

## ~~6. Filter the search by tags~~

* enhancement

-> 1.0

## 7. Add new languages

* shouldo

-> 1.0

It should be great to have the app translated in other languages

## 8. Simple setup

* mustdo

-> 1.0

Running `bin/setup` must do everything needed to be ready to use the
app with different options under different OS

## 9. Have a complete test suite

* mustdo

-> 1.0

A complete test suite must be there before the 1.0 version to ensure
smooth security update and a complete app description

## ~~10. Download the document by clicking on his preview~~

* mustdo

-> 1.0

## 11. Upload directly a document with a progress bar

* enhancement
* wouldo

Use direct upload. It also work without but it is less user friendly

## 12. Enable suggestion when searching

* enhancement
* wouldo

Not required for production release but would boost the use of the search bar

## 13. Investigate for automatic OCR of uploaded document

* research
* couldo

It would be great to have automatic OCR on uploadede document with user
selecting text boxes when needed. Have a look to tesseract-js.

The adventages are:

* Full text search on the content of all document
* Generate PDF with high quality graphics and text (nit just images)
* have the possibility to edit/complete/annontate the documents
