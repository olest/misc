#!/usr/bin/python

import re
import mechanize
import sys
import datetime


#offline version off the python script, without the fancy e-mail stuff


class Constants :

	URL = 'http://www.nationalrail.co.uk'
	STATION = 'Great Chesterford'


def main() :

    now = datetime.datetime.now()
    print 'Current date and time'
    print str(now)

    br = mechanize.Browser()
    response = br.open(Constants.URL)
    assert br.viewing_html()
    print br.title()

    #for form in br.forms():
    #    print "Form name:", form.name
    #    print form

    br.select_form("ldb") 
    #for control in br.form.controls:
        #print control
    #    print "type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

    control = br.form.find_control("mainStation")
    br["mainStation"] = Constants.STATION
    response          = br.submit()
    r                 = response.read()

    print r

if __name__ == "__main__" :
	main()

