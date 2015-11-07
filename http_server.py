from server.http_handler import HttpHandler  # Class import

# If you import:
# from server import http_handler
# Then you should use class that way:
# http_handler.HttpHandler

from wsgiref.simple_server import make_server

if __name__ == "__main__":
	def simple_app(handler, environ, start_response):


	    status, ret = handler.handle_request(environ)
	    headers = [('Content-type', 'text/plain')]

	    start_response(status, headers)

	    return ret

	handler = HttpHandler("GET", "/test")
	httpd = make_server('', 8000, lambda *args, **kwargs: simple_app(handler, *args, **kwargs))
	print "Serving on port 8000..."
	httpd.serve_forever()