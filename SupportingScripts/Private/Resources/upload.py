#!/usr/bin/python
import md5
import time
import hashlib
import os
import sys
import optparse
import itertools
import mimetools
import mimetypes
from cStringIO import StringIO
import urllib
import urllib2

class MultiPartForm(object):
    """Accumulate the data to be used when posting a form."""
    
    def __init__(self):
        self.form_fields = []
        self.files = []
        self.boundary = mimetools.choose_boundary()
        return
    
    def get_content_type(self):
        return 'multipart/form-data; boundary=%s' % self.boundary
    
    def add_field(self, name, value):
        """Add a simple field to the form data."""
        self.form_fields.append((name, value))
        return
    
    def add_file(self, fieldname, filename, fileHandle, mimetype=None):
        """Add a file to be uploaded."""
        body = fileHandle.read()
        if mimetype is None:
            mimetype = mimetypes.guess_type(filename)[0] or 'application/octet-stream'
        self.files.append((fieldname, filename, mimetype, body))
        return
    
    def __str__(self):
        """Return a string representing the form data, including attached files."""
        # Build a list of lists, each containing "lines" of the
        # request.  Each part is separated by a boundary string.
        # Once the list is built, return a string where each
        # line is separated by '\r\n'.
        parts = []
        part_boundary = '--' + self.boundary

        # Add the form fields
        parts.extend(
             [ part_boundary,
              'Content-Disposition: form-data; name="%s"' % name,
              '',
              value,
              ]
             for name, value in self.form_fields
             )
    
        # Add the files to upload
        parts.extend(
            [ part_boundary,
            'Content-Disposition: file; name="%s"; filename="%s"' % \
            (field_name, filename),
            'Content-Type: %s' % content_type,
            '',
            body,
            ]
            for field_name, filename, content_type, body in self.files
            )

        # Flatten the list and add closing boundary marker,
        # then return CR+LF separated data
        flattened = list(itertools.chain(*parts))
        flattened.append('--' + self.boundary + '--')
        flattened.append('')
        return '\r\n'.join(flattened)

parser = optparse.OptionParser(usage="%prog [options]. %prog -h for help.")
parser.add_option("-f", "--file", dest="fileName", help="File name", metavar="FILE")
parser.add_option("-a", "--apikey", dest="apiKey", help="Oneskyapp API public key", metavar="APIKEY")
parser.add_option("-s", "--secretkey", dest="secretKey", help="Oneskyapp API secretkey key", metavar="SECRETKEY")
parser.add_option("-l", "--locale", dest="locale", help="Translation locale (two-character)", metavar="LOCALE")
parser.add_option("-p", "--project", dest="projectId", help="Oneskyapp project ID", metavar="PROJECT_ID")
parser.add_option("-r", "--fileformat", dest="fileFormat", help="Oneskyapp File format", metavar="FILE_FORMAT")
(options, args) = parser.parse_args(sys.argv)

if (not options.fileName):
    parser.error('File name not given')
if (not options.apiKey):
    parser.error('API public key not given')
if (not options.secretKey):
    parser.error('API secret key not given')
if (not options.locale):
    parser.error('Locale not given')
if (not options.projectId):
    parser.error('Project ID not given')
if (not options.fileFormat):
    parser.error('File format name not given')

timestamp = str(int(time.time()))
devHash = md5.new(timestamp + options.secretKey).hexdigest()

url = "https://platform.api.onesky.io/1/projects/"
url += options.projectId
url += "/files"

# Create the form with simple fields
form = MultiPartForm()
form.add_field('locale', options.locale)
form.add_field('file_format', options.fileFormat)
form.add_field('is_keeping_all_strings', 'false')
form.add_field('api_key', options.apiKey)
form.add_field('timestamp', timestamp)
form.add_field('dev_hash', devHash)
form.add_file('file', options.fileName, open(options.fileName, "rb"))

request = urllib2.Request(url)

body = str(form)

request.add_header('Content-type', form.get_content_type())
request.add_header('Content-length', len(body))

request.add_data(body)

#print
#print 'OUTGOING DATA:'
#print request.get_data()
print
print "Uploading " + options.fileName + " for " + options.locale + " locale to Oneskyapp"
print 'SERVER RESPONSE:'
print urllib2.urlopen(request).read()

print "File has been successfully uploaded."