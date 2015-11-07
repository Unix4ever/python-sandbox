#!/usr/bin/python
import argparse
import requests
import codecs
import validators

from urlparse import urlparse


def create_arg_parser():
    parser = argparse.ArgumentParser(description="Get URL address and put result to file")
    parser.add_argument("-u", "--url-address", dest="url_address", help="URL address", required=True, type=check_url)
    parser.add_argument("-o", "--output-file", dest="output_file", help="File path for result", required=True)
    return parser


def check_url(value):
    validate_url = urlparse(value)
    if validate_url.scheme not in ["http", "https"]:
        raise argparse.ArgumentTypeError("%s is an invalid url: %s" % (value, "scheme not supported"))

    validate_url = validators.url(value)
    if isinstance(validate_url, validators.ValidationFailure):
        raise argparse.ArgumentTypeError("%s is an invalid url: %s" % (value, validate_url))
    return value


if __name__ == "__main__":
    arg_parser = create_arg_parser()
    options = arg_parser.parse_args()   # return object with args
    print "url-address %s output-file %s" % (options.url_address, options.output_file)

    r = requests.get(options.url_address)
    print r.status_code
    #print r.encoding
    #print r.text

    file = codecs.open(options.output_file, "w", r.encoding)
    file.write(r.text)
    file.close()