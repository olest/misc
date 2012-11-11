#!/usr/bin/python

import re
import mechanize

import datetime
now = datetime.datetime.now()

url = 'http://www.nationalrail.co.uk'
#url = 'ojp.nationalrail.co.uk/'

print 'Current date and time'
print str(now)

br = mechanize.Browser()
response = br.open(url)
# follow second link with element text matching regular expression
assert br.viewing_html()
#print br.title()
# show html content
#print response.read()

#for form in br.forms():
#    print "Form name:", form.name
#    print form

br.select_form("ldb") 
#for control in br.form.controls:
    #print control
#    print "type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

control = br.form.find_control("mainStation")
#control.value = "Great Chesterford"
br["mainStation"] = "Great Chesterford" 
response = br.submit()
r = response.read()

fh = open('timetable.html','w')
fh.write(r)
fh.close()

