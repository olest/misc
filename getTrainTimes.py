#!/usr/bin/python

import re
import mechanize
import smtplib
import sys

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#import datetime

def getOptions() :
	"""
	get commandline options
	"""

	from optparse import OptionParser

	#parser = OptionParser(usage="usage: %prog --senderEmail <string> --recipientEmail <string>  ", description="Apply filtering to grouper's somatic vcf output")
	parser = OptionParser()

	parser.add_option('--senderEmail', dest='senderEmail',help='Sender')
	parser.add_option('--recipientEmail', dest='recipientEmail',help='Recipient')
	parser.add_option('--smtpPassword', dest='smtpPass',help='SMTP password')
	(options, args) = parser.parse_args()
 
 	# check for any errors or missing requirements from argument parsing:
 	if len(args) :
		parser.print_help()
 		sys.exit(2)

	return options;


class Constants :

	URL = 'http://www.nationalrail.co.uk'
	STATION = 'Great Chesterford'


def main() :

	options = getOptions()

	#now = datetime.datetime.now()
	#print 'Current date and time'
	#print str(now)

	br = mechanize.Browser()
	response = br.open(Constants.URL)
	assert br.viewing_html()
	#print br.title()

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

	msg            = MIMEMultipart('alternative')
	msg['Subject'] = "Timetable info"
	msg['From']    = options.senderEmail
	msg['To']      = options.recipientEmail

	# send timetable info as HTML attachment
	html = MIMEText(r, 'html')
	msg.attach(html)

	print "Sending from ",options.senderEmail," to ",options.recipientEmail

	# send e-mail
	try:
		s = smtplib.SMTP('smtp.gmx.com')
		s.login(options.senderEmail,options.smtpPass);
		s.sendmail(options.senderEmail, options.recipientEmail, msg.as_string())          
		s.quit()
		print "Successfully sent email"
	except smtplib.SMTPException:
		print "Error: unable to send email"


if __name__ == "__main__" :
	main()

